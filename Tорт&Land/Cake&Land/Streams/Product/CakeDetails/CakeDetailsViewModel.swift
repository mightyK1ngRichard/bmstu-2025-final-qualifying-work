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
import SwiftData
import Combine

@Observable
final class CakeDetailsViewModel: CakeDetailsDisplayData, CakeDetailsViewModelInput {
    var bindingData: CakeDetailsModel.BindingData
    private(set) var cakeModel: CakeModel
    @ObservationIgnored
    private var showFeedbackButton = false
    @ObservationIgnored
    private let reviewsService: ReviewsService
    // Network
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    // UI
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private var modelContext: ModelContext?
    @ObservationIgnored
    private var coordinator: Coordinator!
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()

    init(
        cake: CakeModel,
        isOwnedByUser: Bool,
        cakeService: CakeService,
        reviewsService: ReviewsService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        bindingData = CakeDetailsModel.BindingData(showOwnerButton: !isOwnedByUser)
        self.cakeModel = cake
        self.cakeService = cakeService
        self.reviewsService = reviewsService
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
    }

    private var visableButtonTitle: String {
        cakeModel.status == .approved
            ? String(localized: "hide for sale").uppercased()
            : String(localized: "open for sale").uppercased()
    }
}

// MARK: - Network

extension CakeDetailsViewModel {

    func fetchCakeDetails() {
        bindingData.isLoading = true

        Task { @MainActor in
            var fetchedCakeModel = cakeModel
            var fillings: [FillingEntity] = []
            var categories: [CategoryEntity] = []

            do {
                // Получаем подробную информацию торта
                let res = try await cakeService.fetchCakeByID(cakeID: cakeModel.id)
                fetchedCakeModel = CakeModel(from: res.cake)
                showFeedbackButton = res.canWriteFeedback
                fillings = res.cake.fillings
                categories = res.cake.categories

                // Обновляем запись торта в памяти
                await updateCakeInMemory(for: res.cake)
            } catch {
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)

                // Тянем данные торта из памяти устройства
                if let cakeEntity = try? await fetchCakeFromMemory(cakeID: cakeModel.id) {
                    fetchedCakeModel = CakeModel(from: cakeEntity)
                    fillings = cakeEntity.fillings
                    categories = cakeEntity.categories
                }
            }

            // Preview изображение подставляем из переданной модели, чтобы не тянуть лишний раз изображение
            fetchedCakeModel.previewImageState = cakeModel.previewImageState
            cakeModel = fetchedCakeModel

            bindingData.isLoading = false

            // Тянем изображения
            fetchThumbnails(cakeImages: fetchedCakeModel.thumbnails)
            fetchFillingsImages(fillings: fillings)
            fetchCategoriesImages(categories: categories)
        }
    }

    /// Получаем изображения торта
    private func fetchThumbnails(cakeImages: [Thumbnail]) {
        for thumbnail in cakeImages {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: thumbnail.url)
                if let index = cakeModel.thumbnails.firstIndex(where: { $0.id == thumbnail.id }) {
                    cakeModel.thumbnails[safe: index]?.imageState = imageState
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
                    cakeModel.categories[safe: index]?.imageState = imageState
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
                    cakeModel.fillings[safe: index]?.imageState = imageState
                }
            }
        }
    }

}

// MARK: - Memory

private extension CakeDetailsViewModel {

    @MainActor
    func updateCakeInMemory(for cakeEntity: CakeEntity) async {
        guard let modelContext else {
            return
        }

        await SDMemoryManager.shared.saveOrUpdateCakeInMemory(cakeEntity: cakeEntity, using: modelContext)
    }

    @MainActor
    func fetchCakeFromMemory(cakeID: String) async throws -> CakeEntity? {
        guard let modelContext else {
            return nil
        }

        return try await SDMemoryManager.shared
            .fetchCakeFromMemory(cakeID: cakeID, using: modelContext)?
            .asCakeEntity
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
                content: AlertContent(
                    title: StringConstants.modelErrorTitle,
                    message: StringConstants.modelErrorSubtitle
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
        Task { @MainActor in
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
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
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
        let view = RatingReviewsAssembler.assemble(
            cakeID: cakeModel.id,
            showFeedbackButton: showFeedbackButton,
            reviewsService: reviewsService,
            imageProvider: imageProvider
        )

        view.viewModel.addFeedbackPublisher
            .sink { [weak self] feedback in
                guard let self else { return }

                var startsSum = cakeModel.rating * cakeModel.reviewsCount
                startsSum += feedback.rating
                cakeModel.reviewsCount += 1
                cakeModel.rating = Int(startsSum / cakeModel.reviewsCount)

            }
            .store(in: &cancellables)

        return view
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
    func setEnvironmentObjects(coordinator: Coordinator, modelContext: ModelContext) {
        self.coordinator = coordinator
        self.modelContext = modelContext
    }
}
