//
//  CakeDetailsViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Core
import NetworkAPI
import DesignSystem

@Observable
final class CakeDetailsViewModel: CakeDetailsDisplayData, CakeDetailsViewModelInput {
    var bindingData: CakeDetailsModel.BindingData
    private(set) var cakeModel: CakeModel
    @ObservationIgnored
    private var showFeedbackButton = false
    @ObservationIgnored
    private let reviewsService: ReviewsService
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private var coordinator: Coordinator!
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private let rootViewModel: RootViewModelOutput

    init(
        cakeModel: CakeModel,
        isOwnedByUser: Bool,
        cakeService: CakeService,
        reviewsService: ReviewsService,
        imageProvider: ImageLoaderProvider,
        rootViewModel: RootViewModelOutput,
        priceFormatter: PriceFormatterService = .shared
    ) {
        bindingData = CakeDetailsModel.BindingData(showOwnerButton: !isOwnedByUser)
        self.cakeModel = cakeModel
        self.cakeService = cakeService
        self.reviewsService = reviewsService
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
        self.rootViewModel = rootViewModel
    }

    private var visableButtonTitle: String {
        cakeModel.status == .approved ? "Hide for sale" : "Open for sale"
    }
}

// MARK: - Network

extension CakeDetailsViewModel {

    func fetchCakeDetails() {
        bindingData.isLoading = true

        Task { @MainActor in
            do {
                let res = try await cakeService.fetchCakeByID(cakeID: cakeModel.id)
                cakeModel = cakeModel.applyDetails(res.cake)
                showFeedbackButton = res.canWriteFeedback
                bindingData.isLoading = false

                fetchThumbnails(cakeImages: cakeModel.thumbnails)
                fetchCategoriesImages(categories: res.cake.categories)
                fetchFillingsImages(fillings: res.cake.fillings)
                fetchSellerImages(imageURL: res.cake.owner.imageURL, headerImage: res.cake.owner.headerImageURL)

                // Обновляем торт
                rootViewModel.updateCake(res.cake)
            } catch {
                bindingData.isLoading = false
                // TODO: Показать ошибку
            }
        }
    }
    
    /// Получаем изображения продавца
    private func fetchSellerImages(imageURL: String?, headerImage: String?) {
        Task { @MainActor in
            guard let imageURL else {
                cakeModel.seller.avatarImage = .fetched(.uiImage(TLAssets.profile))
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageURL)
            cakeModel.seller.avatarImage = imageState
        }

        Task { @MainActor in
            guard let headerImage else {
                cakeModel.seller.headerImage = .fetched(.uiImage(.mockHeader))
                return
            }

            let imageState = await imageProvider.fetchImage(for: headerImage)
            cakeModel.seller.headerImage = imageState
        }
    }

    /// Получаем изображения торта
    private func fetchThumbnails(cakeImages: [Thumbnail]) {
        for thumbnail in cakeImages {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: thumbnail.url)
                if let index = cakeModel.thumbnails.firstIndex(where: { $0.id == thumbnail.id }) {
                    cakeModel.thumbnails[index].imageState = imageState
                }
            }
        }
    }

    /// Получаем изображения категорий торта
    private func fetchCategoriesImages(categories: [CategoryEntity]) {
        for category in categories {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: category.imageURL)
                if let index = cakeModel.categories.firstIndex(where: { $0.id == category.id }) {
                    cakeModel.categories[index].imageState = imageState
                }
            }
        }
    }

    /// Получаем изображения начинок торта
    private func fetchFillingsImages(fillings: [FillingEntity]) {
        for filling in fillings {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: filling.imageURL)
                if let index = cakeModel.fillings.firstIndex(where: { $0.id == filling.id }) {
                    cakeModel.fillings[index].imageState = imageState
                }
            }
        }
    }

}

// MARK: - Actions

extension CakeDetailsViewModel {

    func didTapMakeOrderButton() {
        coordinator?.addScreen(RootModel.Screens.makeOrder(cakeID: cakeModel.id))
    }

    func didTapSellerInfoButton() {
        coordinator.addScreen(RootModel.Screens.profile(cakeModel.seller))
    }

    func didTapRatingReviewsButton() {
        coordinator.addScreen(CakeDetailsModel.Screens.ratingReviews)
    }

    func didTapBackButton() {
        coordinator.openPreviousScreen()
    }

    func didTapSimilarCake(model: CakeModel) {
        coordinator.addScreen(RootModel.Screens.details(model))
    }

    func didTapCakeLike(model: CakeModel, isSelected: Bool) {}

    func didTapFilling(with filling: Filling) {
        bindingData.selectedFilling = filling
        bindingData.showSheet = true
    }

    func didTap3DButton() {
        guard let modelURL = cakeModel.model3DURLProd else {
            bindingData.alert = AlertModel(
                errorContent: ErrorContent(
                    title: "Model Error",
                    message: "The 3D model URL is missing or incorrectly formatted."
                ),
                isShown: true
            )
            return
        }

        coordinator?.addScreen(CakeDetailsModel.Screens.arQuickView(remoteURL: modelURL))
    }

    func didTapAdd3DModel() {
        bindingData.openFileDirecatory = true
    }

    func didSelectFile(url: URL) {
        Task {
            let fileData = try Data(contentsOf: url)
            let model3DURL = try await cakeService.add3DModel(cakeID: cakeModel.id, modelData: fileData)
            cakeModel.model3DURL = model3DURL
        }
    }

    func didTapUpdateVisable() {
        bindingData.visableButtonIsLoading = true
        Task { @MainActor in
            let updatedStatus: CakeStatus = cakeModel.status == .approved ? .hidden : .approved

            do {
                try await cakeService.updateCakeVisibility(cakeID: cakeModel.id, status: updatedStatus.toProto)
                cakeModel.status = updatedStatus
            } catch {
            }

            bindingData.visableButtonIsLoading = false
        }
    }

}

// MARK: - Configuration

extension CakeDetailsViewModel {

    func configurePreviewImageViewConfiguration() -> TLImageView.Configuration {
        .init(imageState: cakeModel.previewImageState)
    }

    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration {
        .init(imageState: thumbnail.imageState)
    }

    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration {
        model.configureProductCard(priceFormatter: priceFormatter)
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        cakeModel.configureDescriptionView(priceFormatter: priceFormatter)
    }

    func assemblyRatingReviewsView() -> RatingReviewsView {
        RatingReviewsAssembler.assemble(
            cakeID: cakeModel.id,
            showFeedbackButton: showFeedbackButton,
            reviewsService: reviewsService,
            imageProvider: imageProvider
        )
    }

    func configureFillingDetails(for filling: Filling) -> FillingDetailView.Configuration {
        .init(
            name: filling.name,
            imageState: filling.imageState,
            content: filling.content,
            kgPrice: priceFormatter.formatKgPrice(filling.kgPrice),
            description: filling.description
        )
    }

    func visableButtonConfiguration() -> TLButton.Configuration {
        .init(title: visableButtonTitle, kind: bindingData.visableButtonIsLoading ? .loading : .default)
    }

}

// MARK: - Setters

extension CakeDetailsViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }
}
