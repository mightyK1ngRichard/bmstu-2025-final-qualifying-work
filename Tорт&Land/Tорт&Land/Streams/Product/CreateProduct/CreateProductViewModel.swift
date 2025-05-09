//
//  CreateProductViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Observation
import UIKit
import _PhotosUI_SwiftUI
import DesignSystem

@Observable
final class CreateProductViewModel: CreateProductDisplayLogic, CreateProductViewModelInput {
    var uiProperties = CreateProductModel.UIProperties()
    private(set) var selectedImages: [UIImage] = []

    @ObservationIgnored
    var addFCViewModel: AddFillingsAndCategoriesViewModel
    @ObservationIgnored
    private let cakeProvider: CakeService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private var coordinator: Coordinator!

    init(
        cakeProvider: CakeService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.cakeProvider = cakeProvider
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
        addFCViewModel = AddFillingsAndCategoriesViewModel(
            cakeService: cakeProvider,
            imageProvider: imageProvider
        )
    }
}

// MARK: - Actions

extension CreateProductViewModel {

    func didCloseProductInfoSreen() {
        uiProperties.currentPage += 1
    }

    func didTapCloseFillingCategoriesScreen() {
        uiProperties.currentPage += 1
    }

    func didCloseProductImagesScreen() {
        uiProperties.currentPage += 1

        // Конвертирует Data -> UIImage
        Task { @MainActor in
            selectedImages = await withTaskGroup(of: UIImage?.self, returning: [UIImage].self) { group in
                for imageData in uiProperties.selectedPhotosData {
                    group.addTask {
                        return UIImage(data: imageData)
                    }
                }

                var uiImages: [UIImage] = []
                uiImages.reserveCapacity(uiProperties.selectedPhotosData.count)
                for await uiImage in group {
                    if let uiImage {
                        uiImages.append(uiImage)
                    }
                }

                return uiImages
            }
        }
    }

    func didCloseResultScreen() {
        didTapCreateProduct()
    }

    func didTapCreateProduct() {
        let alertTitle = "Invalid input data"
        let alertMessage = "Please, fill all fields correctly. KG price, mass and discounted price must be numbers"

        guard
            let previewImage = uiProperties.selectedPhotosData.first,
            let kgPrice = Double(uiProperties.inputPrice),
            let mass = Double(uiProperties.inputMass)
        else {
            uiProperties.alert = AlertModel(
                errorContent: .init(title: alertTitle, message: alertMessage),
                isShown: true
            )
            return
        }

        // Если есть скидка, но она не число
        if !uiProperties.inputDiscountedPrice.isEmpty && Double(uiProperties.inputDiscountedPrice) == nil {
            uiProperties.alert = AlertModel(
                errorContent: .init(title: alertTitle, message: alertMessage),
                isShown: true
            )
            return
        }

        // Дата окончания скидки, если есть скидка
        var discountEndTime: Date?
        var discountedPrice: Double?
        if !uiProperties.inputDiscountedPrice.isEmpty {
            discountEndTime = uiProperties.discountEndDate
            discountedPrice = Double(uiProperties.inputDiscountedPrice)
        }

        Task { @MainActor in
            do {
                let response = try await cakeProvider.createCake(
                    req: .init(
                        name: uiProperties.inputName,
                        previewImageData: previewImage,
                        kgPrice: kgPrice,
                        description: uiProperties.inputDescription,
                        mass: mass,
                        isOpenForSale: true,
                        discountEndTime: discountEndTime,
                        discountKgPrice: discountedPrice,
                        fillingIDs: Array(addFCViewModel.selectedFillingsIDs),
                        categoryIDs: Array(addFCViewModel.selectedCategoriesIDs),
                        imagesData: Array(uiProperties.selectedPhotosData.dropFirst())
                    )
                )
                coordinator.openPreviousScreen()
                generateCakeColors(cakeID: response.cakeID)
            } catch {
                uiProperties.alert = AlertModel(errorContent: error.readableGRPCContent, isShown: true)
            }
        }
    }

    /// Генерируем цвета из превью
    func generateCakeColors(cakeID: String) {
        Task {
            guard
                let previewData = uiProperties.selectedPhotosData.first,
                let uiImage = UIImage(data: previewData)
            else { return }

            let hexStrings = extractPaletteHexColors(from: uiImage)
            try await cakeProvider.addCakeColors(req: .init(cakeID: cakeID, hexStrings: hexStrings))
        }
    }

    func didTapCancelProduct() {}

    func didTapDeleteProduct() {}

    func didTapBackScreen() {
        coordinator.openPreviousScreen()
    }

    func updateImages(_ oldValue: [PhotosPickerItem], _ newValue: [PhotosPickerItem]) {
        guard oldValue.count != newValue.count else { return }

        // Если какой-то элемент пропал
        if oldValue.count > newValue.count {
            oldValue.forEach { item in
                Task(priority: .high) { @MainActor in
                    guard
                        !newValue.contains(item),
                        let data = try? await item.loadTransferable(type: Data.self),
                        let index = uiProperties.selectedPhotosData.firstIndex(where: { $0 == data })
                    else { return }

                    uiProperties.selectedPhotosData.remove(at: index)
                }
            }
            return
        }

        // Если добавили новое фото
        Task(priority: .high) { @MainActor in
            guard
                let newImage = newValue.last,
                let data = try? await newImage.loadTransferable(type: Data.self)
            else { return }
            
            uiProperties.selectedPhotosData.append(data)
        }
    }

}

// MARK: - Configurations

extension CreateProductViewModel {
    func configureTLProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        .basic(
            title: uiProperties.inputName,
            price: priceFormatter.formatKgPrice(uiProperties.inputPrice),
            discountedPrice: uiProperties.inputDiscountedPrice.isEmpty ? nil : priceFormatter.formatKgPrice(uiProperties.inputDiscountedPrice),
            subtitle: "your name",
            description: uiProperties.inputDescription,
            starsConfiguration: .init()
        )
    }
}

// MARK: - Screens

extension CreateProductViewModel {
    func assembleCreateCakeInfoView() -> CreateCakeInfoView {
        CreateCakeInfoView(viewModel: self)
    }

    func assemblyAddProductImages() -> AddProductImages {
        AddProductImages(viewModel: self) { [weak self] in
            guard let self else { return }
            uiProperties.selectedPhotosData.removeAll()
            uiProperties.currentPage -= 1
        }
    }

    func assemblyProductResultScreen() -> ProductResultScreen {
        ProductResultScreen(viewModel: self) { [weak self] in
            self?.uiProperties.currentPage -= 1
        }
    }

    func assemblyFillingsAndCategoriesView() -> AddFillingsAndCategoriesView {
        AddFillingsAndCategoriesView(viewModel: addFCViewModel) { [weak self] in
            self?.uiProperties.currentPage -= 1

        }
    }
}

// MARK: - Setters

extension CreateProductViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func onAppearAddProductImages() {
        selectedImages.removeAll()
        uiProperties.selectedPhotosData.removeAll()
    }
}
