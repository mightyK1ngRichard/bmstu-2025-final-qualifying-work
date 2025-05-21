//
//  CategoriesViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 14.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftUI
import SwiftData
import Core

@Observable
final class CategoriesViewModel: CategoriesDisplayLogic, CategoriesViewModelInput {
    var uiProperties = CategoriesModel.UIProperties()
    private(set) var tabs: [CategoriesModel.Tab] = CategoriesModel.Tab.allCases
    private(set) var sections: [CategoriesModel.Tab: [CategoryCardModel]] = [:]
    @ObservationIgnored
    private let cakeProvider: CakeService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private var modelContext: ModelContext?
    @ObservationIgnored
    private var coordinator: Coordinator!
    @ObservationIgnored
    private var selectedSection: CategoryCardModel?
    @ObservationIgnored
    private var memoryCategories: [SDCategory] = []

    init(cakeProvider: CakeService, imageProvider: ImageLoaderProvider) {
        self.cakeProvider = cakeProvider
        self.imageProvider = imageProvider
    }

    func onAppear() {
        fetchCategories(fromMemory: false)
    }

    func setEnvironmentObjects(coordinator: Coordinator, modelContext: ModelContext) {
        self.modelContext = modelContext
        self.coordinator = coordinator
    }

    func filterData(categories: [CategoryCardModel]) -> [CategoryCardModel] {
        uiProperties.searchText.isEmpty
            ? categories
            : categories.filter {
                $0.title.lowercased().contains(uiProperties.searchText.lowercased())
            }
    }
}

// MARK: - Navigation

extension CategoriesViewModel {

    func assemlyCakesCategoryView(cakes: [CakeModel]) -> ProductsGridView {
        ProductsGridAssemler.assembly(cakes: cakes, cakeService: cakeProvider)
    }

}

// MARK: - Memory

private extension CategoriesViewModel {

    @MainActor
    func fetchFromMemory() async throws -> [SDCategory] {
        guard memoryCategories.isEmpty else {
            return memoryCategories
        }

        guard let modelContext else {
            return []
        }

        return try await SDMemoryManager.shared.fetchCategoriesFromMemory(using: modelContext)
    }

    @MainActor
    func fetchCategoryCakesFromMemory() async throws -> [PreviewCakeEntity] {
        guard let selectedSection,
              let modelContext
        else { return [] }

        guard let category = try await SDMemoryManager.shared.fetchCategoryFromMemory(
            categoryID: selectedSection.id,
            using: modelContext
        ) else {
            return []
        }

        return category.cakes?.compactMap(\.asPreviewEntity) ?? []
    }

}

// MARK: - Actions

extension CategoriesViewModel {

    func didTapLoadSavedData() {
        fetchCategories(fromMemory: true)
    }

    func didTapTab(tab: CategoriesModel.Tab) {
        uiProperties.selectedTab = tab
    }

    func didTapSearchToggle() {
        uiProperties.showSearchBar.toggle()
    }

    func didTapSectionCell(section: CategoryCardModel, fromMemory: Bool) {
        selectedSection = section

        Task { @MainActor in
            do {
                var cakesModel: [CakeModel]
                var previewImages: [String] = []

                if !fromMemory {
                    let result = try await cakeProvider.fetchCategoryCakes(categoryID: section.id)
                    let cakes = result.cakes.filter { $0.status == .approved }
                    cakesModel = cakes.map {
                        previewImages.append($0.previewImageURL)
                        return CakeModel.init(from: $0)
                    }
                } else {
                    let cakes = try await fetchCategoryCakesFromMemory()
                    cakesModel = cakes.map {
                        previewImages.append($0.imageURL)
                        return CakeModel.init(from: $0)
                    }
                }

                // Подгружаем картинки
                await withTaskGroup(of: (Int, ImageState).self) { group in
                    for (index, previewImageURL) in previewImages.enumerated() {
                        group.addTask {
                            let imageState = await self.imageProvider.fetchImage(for: previewImageURL)
                            return (index, imageState)
                        }
                    }

                    for await (index, imageState) in group {
                        cakesModel[index].previewImageState = imageState
                    }
                }

                coordinator.addScreen(CategoriesModel.Screens.cakes(cakesModel))
            } catch {
                uiProperties.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
            }
        }
    }

    func didTapMemoryCakes() {
        guard let selectedSection else {
            return
        }

        didTapSectionCell(section: selectedSection, fromMemory: true)
    }

    func didUpdateSelectedTag(section: CategoriesModel.Tab) {
        fetchSubcategories(tab: section)
    }

}

// MARK: - Helpers

private extension CategoriesViewModel {

    func fetchSubcategories(tab: CategoriesModel.Tab) {
        Task { @MainActor in
            do {
                let result = try await cakeProvider.fetchCategoriesByGenderName(
                    gender: tab.convertToCategoryGender()
                )

                // Создаём словарь айдишников секций
                guard let ids = (sections[tab]?.reduce(into: [:]) { result, section in
                    result[section.id] = true
                }) else {
                    return
                }

                for section in result.categories {
                    // Если такой категории нет, добавляем её
                    if !(ids[section.id] == true) {
                        sections[tab]?.append(CategoryCardModel(from: section))
                        fetchSectionImage(tab: tab, entity: section)
                    }
                }
            } catch {
                uiProperties.state = .error(content: error.readableGRPCContent)
            }
        }
    }

    func fetchCategories(fromMemory: Bool) {
        uiProperties.state = .loading

        Task { @MainActor in
            do {
                var categories: [CategoryEntity] = []
                if !fromMemory {
                    let result = try await cakeProvider.fetchCategories()
                    categories = result.categories
                } else {
                    memoryCategories = try await fetchFromMemory()
                    categories = memoryCategories.map(\.asEntity)
                }

                fetchSectionsImages(entities: categories)

                var males: [CategoryCardModel] = []
                var females: [CategoryCardModel] = []
                var childs: [CategoryCardModel] = []
                for category in categories {
                    for tag in category.genderTags {
                        let model = CategoryCardModel(from: category)
                        switch tag {
                        case .male:
                            males.append(model)
                        case .female:
                            females.append(model)
                        case .child:
                            childs.append(model)
                        }
                    }
                }

                sections[.women] = females
                sections[.men] = males
                sections[.kids] = childs

                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(content: error.readableGRPCContent)
            }
        }
    }

    func fetchSectionsImages(entities: [CategoryEntity]) {
        for section in entities {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: section.imageURL)
                for tab in section.genderTags {
                    let sectionIndex: CategoriesModel.Tab = switch tab {
                    case .male: .men
                    case .female: .women
                    case .child: .kids
                    }

                    guard let index = sections[sectionIndex]?.firstIndex(where: { $0.id == section.id }) else {
                        continue
                    }

                    sections[sectionIndex]?[safe: index]?.imageState = imageState
                }
            }
        }
    }

    func fetchSectionImage(tab: CategoriesModel.Tab, entity: CategoryEntity) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: entity.imageURL)
            if let index = sections[tab]?.firstIndex(where: { $0.id == entity.id }) {
                sections[tab]?[safe: index]?.imageState = imageState
            }
        }
    }
}
