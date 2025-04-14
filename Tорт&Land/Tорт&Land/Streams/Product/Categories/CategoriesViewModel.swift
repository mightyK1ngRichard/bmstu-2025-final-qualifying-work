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

@Observable
final class CategoriesViewModel: CategoriesDisplayLogic, CategoriesViewModelOutput {
    var uiProperties = CategoriesModel.UIProperties()
    private(set) var tabs: [CategoriesModel.Tab] = CategoriesModel.Tab.allCases
    private(set) var sections: [CategoriesModel.Tab: [CategoryCardModel]] = [:]
    @ObservationIgnored
    private let cakeProvider: CakeGrpcService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private var coordinator: Coordinator!

    init(cakeProvider: CakeGrpcService, imageProvider: ImageLoaderProvider) {
        self.cakeProvider = cakeProvider
        self.imageProvider = imageProvider
    }

    func onAppear() {
        uiProperties.errorMessage = nil
        fetchCategories()
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
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
        ProductsGridAssemler.assembly(cakes: cakes, sectionKind: .default)
    }
}

// MARK: - Actions

extension CategoriesViewModel {
    func didTapTab(tab: CategoriesModel.Tab) {
        withAnimation(.snappy) {
            uiProperties.selectedTab = tab
        }
    }

    func didTapSearchToggle() {
        withAnimation {
            uiProperties.showSearchBar.toggle()
        }
    }

    func didTapSectionCell(section: CategoryCardModel) {
        Task {
            do {
                let result = try await cakeProvider.fetchCategoryCakes(categoryID: section.id)
                var cakesModel: [CakeModel] = []
                cakesModel.reserveCapacity(result.cakes.count)

                // сначала заполняем массив
                for cake in result.cakes {
                    cakesModel.append(CakeModel(from: cake))
                }

                // теперь подгружаем картинки параллельно
                await withTaskGroup(of: (Int, ImageState).self) { group in
                    for (index, cake) in result.cakes.enumerated() {
                        group.addTask {
                            let imageState = await self.imageProvider.fetchImage(for: cake.previewImageURL)
                            return (index, imageState)
                        }
                    }

                    for await (index, imageState) in group {
                        cakesModel[index].previewImageState = imageState
                    }
                }

                coordinator.addScreen(CategoriesModel.Screens.cakes(cakesModel))
            } catch {
            }
        }
    }

    func didUpdateSelectedTag(section: CategoriesModel.Tab) {
        fetchCategories(tab: section)
    }
}

// MARK: - Helpers

private extension CategoriesViewModel {
    func fetchCategories(tab: CategoriesModel.Tab) {
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
                uiProperties.errorMessage = error.localizedDescription
            }
        }
    }

    func fetchCategories() {
        uiProperties.showLoading = true
        Task { @MainActor in
            do {
                let result = try await cakeProvider.fetchCategories()
                fetchSectionsImages(entities: result.categories)

                var males: [CategoryCardModel] = []
                var females: [CategoryCardModel] = []
                var childs: [CategoryCardModel] = []
                for category in result.categories {
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
            } catch {
                uiProperties.errorMessage = error.localizedDescription
            }

            uiProperties.showLoading = false
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

                    guard
                        let index = sections[sectionIndex]?.firstIndex(where: { $0.id == section.id })
                    else {
                        continue
                    }

                    sections[sectionIndex]?[index].imageState = imageState
                }
            }
        }
    }

    func fetchSectionImage(tab: CategoriesModel.Tab, entity: CategoryEntity) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: entity.imageURL)
            if let index = sections[tab]?.firstIndex(where: { $0.id == entity.id }) {
                sections[tab]?[index].imageState = imageState
            }
        }
    }
}
