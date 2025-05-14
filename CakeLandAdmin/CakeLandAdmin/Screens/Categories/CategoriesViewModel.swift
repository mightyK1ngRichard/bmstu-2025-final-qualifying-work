//
//  CategoriesViewModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 13.05.2025.
//

import Foundation
import Observation
import SwiftUI
import AppKit

@Observable
final class CategoriesViewModel {
    var bindingData = CategoriesModel.BindingData()
    private(set) var categories: [Category] = []
    private(set) var fillings: [Filling] = []
    private(set) var colorsHex: [String] = []
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProviderImpl
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService

    init(
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProviderImpl,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
    }
}

// MARK: - Network

extension CategoriesViewModel {

    func fetchCategories() {
        Task { @MainActor in
            let res = try await networkManager.cakeService.fetchCategories()
            categories = res.categories.map(Category.init(from:))
            for (index, category) in res.categories.enumerated() {
                fetchImage(index: index, urlString: category.imageURL)
            }
        }
    }

    func fetchFillings() {
        Task { @MainActor in
            let res = try await networkManager.cakeService.fetchFillings()
            fillings = res.fillings.map(Filling.init(from:))
            for (index, filling) in res.fillings.enumerated() {
                fetchFillingImage(index: index, urlString: filling.imageURL)
            }
        }
    }

    func fetchColors() {
        Task { @MainActor in
            let res = try await networkManager.cakeService.fetchColors()
            colorsHex = res
        }
    }

    private func fetchImage(index: Int, urlString: String) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: urlString)
            categories[index].thumbnail.imageState = imageState
        }
    }

    private func fetchFillingImage(index: Int, urlString: String) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: urlString)
            fillings[index].thumbnail.imageState = imageState
        }
    }

}

// MARK: - Actions

extension CategoriesViewModel {

    func didTapAddFillingButton() {
        bindingData.sheetKind = .addFilling
        bindingData.isShowingSheet = true
    }

    func didTapAddCategoryButton() {
        bindingData.sheetKind = .addCategory
        bindingData.isShowingSheet = true
    }

    func didTapCancel() {
        switch bindingData.sheetKind {
        case .addCategory:
            bindingData.createCategoryModel.reset()
        case .addFilling:
            bindingData.createFillingModel.reset()
        }

        bindingData.selectedImageData = nil
        bindingData.isShowingSheet = false
    }

    /// Нажали кнопку `создать начинку`
    func didTapCreateFilling() {
        guard let kgPrice = Double(bindingData.createFillingModel.inputKgPrice) else {
            bindingData.createFillingModel.inputError = "Цена за кг должна быть числом"
            return
        }

        guard let nsImageData = bindingData.selectedImageData else {
            return
        }

        Task { @MainActor in
            do {
                let res = try await networkManager.cakeService.createFilling(
                    req: .init(
                        name: bindingData.createFillingModel.inputName.trimmingCharacters(in: .whitespacesAndNewlines),
                        imageData: nsImageData,
                        content: bindingData.createFillingModel.inputContent.trimmingCharacters(in: .whitespacesAndNewlines),
                        kgPrice: kgPrice,
                        description: bindingData.createFillingModel.inputDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                )

                var createdFilling = Filling(from: res.filling)
                if let nsImage = NSImage(data: nsImageData) {
                    createdFilling.thumbnail.imageState = .nsImage(nsImage)
                } else {
                    createdFilling.thumbnail.imageState = .error("не вышло преобозовать изображение")
                }

                fillings.append(createdFilling)
                bindingData.createFillingModel.reset()
                bindingData.selectedImageData = nil
                bindingData.isShowingSheet = false
            } catch {
                bindingData.createFillingModel.inputError = error.readableGRPCContent.message
            }
        }
    }

    /// Нажали кнопку `создать категорию`
    func didTapCreateCategory() {
        guard let nsImageData = bindingData.selectedImageData else {
            return
        }

        Task { @MainActor in
            do {
                let res = try await networkManager.cakeService.createCategory(
                    req: .init(
                        name: bindingData.createCategoryModel.inputName.trimmingCharacters(in: .whitespacesAndNewlines),
                        imageData: nsImageData,
                        genderTags: bindingData.createCategoryModel.selectedGenderTags.map { $0.toProto }
                    )
                )

                var createdCategory = Category(from: res.category)
                if let nsImage = NSImage(data: nsImageData) {
                    createdCategory.thumbnail.imageState = .nsImage(nsImage)
                } else {
                    createdCategory.thumbnail.imageState = .error("не вышло преобозовать изображение")
                }

                categories.append(createdCategory)
                bindingData.createCategoryModel.reset()
                bindingData.selectedImageData = nil
                bindingData.isShowingSheet = false
            } catch {
                bindingData.createFillingModel.inputError = error.readableGRPCContent.message
            }
        }
    }

    func pickImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg, .heic, .tiff]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK else { return }

        if let url = panel.url, let nsImageData = try? Data(contentsOf: url) {
            bindingData.selectedImageData = nsImageData
        }
    }

}

// MARK: - Configuration

extension CategoriesViewModel {

    func configurePriceTitle(price: Double) -> String {
        priceFormatter.formatKgPrice(price)
    }

    func bindingForGender(_ gender: Category.Gender) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                self.bindingData.createCategoryModel.selectedGenderTags.contains(gender)
            },
            set: { isSelected in
                if isSelected {
                    if !self.bindingData.createCategoryModel.selectedGenderTags.contains(gender) {
                        self.bindingData.createCategoryModel.selectedGenderTags.append(gender)
                    }
                } else {
                    self.bindingData.createCategoryModel.selectedGenderTags.removeAll { $0 == gender }
                }
            }
        )
    }

}
