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
    var cakeModel: CakeModel
    var isOwnedByUser: Bool
    private let cakeService: CakeGrpcService
    @ObservationIgnored
    private var coordinator: Coordinator!

    init(
        cakeModel: CakeModel,
        isOwnedByUser: Bool,
        cakeService: CakeGrpcService
    ) {
        self.cakeModel = cakeModel
        self.isOwnedByUser = isOwnedByUser
        self.cakeService = cakeService
    }
}

// MARK: - Network

extension CakeDetailsViewModel {
    func fetchCakeDetails(cakeUID: String) {
        Task {
            // Получение инфы о торте
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
}

// MARK: - Configuration

extension CakeDetailsViewModel {
    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration {
        .init(imageState: thumbnail.imageState)
    }

    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration {
        model.configureProductCard()
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        cakeModel.configureDescriptionView()
    }

    func assemblyRatingReviewsView() -> RatingReviewsView {
        // FIXME: Убрать моки
        let viewModel = RatingReviewsViewModelMock(comments: cakeModel.comments)
        return RatingReviewsView(viewModel: viewModel)
    }
}

// MARK: - Setters

extension CakeDetailsViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }
}
