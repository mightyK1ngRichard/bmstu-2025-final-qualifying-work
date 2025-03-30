//
//  CakeDetailsViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

@Observable
final class CakeDetailsViewModel: CakeDetailsDisplayData & CakeDetailsViewModelInput {
    var bindingData = CakeDetailsModel.BindingData()
    var cakeModel: CakeModel
    @ObservationIgnored
    private(set) var showOwnerButton: Bool
    @ObservationIgnored
    private let cakeService: CakeGrpcService
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
        cakeService: CakeGrpcService,
        imageProvider: ImageLoaderProvider,
        rootViewModel: RootViewModelOutput,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.cakeModel = cakeModel
        self.showOwnerButton = !isOwnedByUser
        self.cakeService = cakeService
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
        self.rootViewModel = rootViewModel
    }
}

// MARK: - Network

extension CakeDetailsViewModel {
    func fetchCakeDetails() {
        bindingData.isLoading = true
        Task { @MainActor in
            do {
                let cakeEntity = try await cakeService.fetchCakeDetails(cakeID: cakeModel.id)
                cakeModel = cakeModel.applyDetails(cakeEntity)
                bindingData.isLoading = false
                fetchThumbnails(cakeImages: cakeModel.thumbnails)
                fetchCategoriesImages(categories: cakeEntity.categories)
                fetchFillingsImages(fillings: cakeEntity.fillings)

                // Обновляем торт
                rootViewModel.updateCake(cakeEntity)
            } catch {
                bindingData.isLoading = false
                // TODO: Показать ошибку
            }
        }
    }

    /// Получаем изображения торта
    private func fetchThumbnails(cakeImages: [Thumbnail]) {
        for thumbnail in cakeImages {
            Task { @MainActor in
                do {
                    let imageState = try await imageProvider.fetchImage(for: thumbnail.url)
                    if let index = cakeModel.thumbnails.firstIndex(where: { $0.id == thumbnail.id }) {
                        cakeModel.thumbnails[index].imageState = imageState
                    }
                } catch {
                    
                }
            }
        }
    }

    /// Получаем изображения категорий торта
    private func fetchCategoriesImages(categories: [CategoryEntity]) {
        for category in categories {
            Task { @MainActor in
                let imageState = try await imageProvider.fetchImage(for: category.imageURL)
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
                let imageState = try await imageProvider.fetchImage(for: filling.imageURL)
                if let index = cakeModel.fillings.firstIndex(where: { $0.id == filling.id }) {
                    cakeModel.fillings[index].imageState = imageState
                }
            }
        }
    }
}

// MARK: - Actions

extension CakeDetailsViewModel {
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
}

// MARK: - Configuration

extension CakeDetailsViewModel {
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
        // FIXME: Убрать моки
        let viewModel = RatingReviewsViewModelMock(comments: cakeModel.comments)
        return RatingReviewsView(viewModel: viewModel)
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
}

// MARK: - Setters

extension CakeDetailsViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }
}
