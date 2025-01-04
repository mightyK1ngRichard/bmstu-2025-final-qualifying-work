//
//  CakeDetailsViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

#if DEBUG

import Foundation

final class CakeDetailsViewModelMock: CakeDetailsDisplayLogic, CakeDetailsViewModelOutput {
    let currentUser = CommonMockData.generateMockUserModel(id: -1, name: "Дмитрий Пермяков")
    var isOwnedByUser: Bool { cakeModel.seller.id == currentUser.id }
    private(set) var cakeModel: CakeModel
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(cakeModel: CakeModel = CommonMockData.generateMockCakeModel(id: 23)) {
        self.cakeModel = cakeModel
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func didTapSellerInfoButton() {}

    func didTapRatingReviewsButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.addScreen(CakeDetailsModel.Screens.ratingReviews)
    }

    func didTapBackButton() {
        coordinator?.openPreviousScreen()
    }

    func didTapSimilarCake(model: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(model))
    }

    func didTapCakeLike(model: CakeModel, isSelected: Bool) {}
}

// MARK: - Configure

extension CakeDetailsViewModelMock {

    func configureRatingReviewsView() -> RatingReviewsView {
        let viewModel = RatingReviewsViewModelMock(comments: cakeModel.comments)
        return RatingReviewsView(viewModel: viewModel)
    }

    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration {
        .init(imageState: thumbnail.imageState)
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        .basic(
            title: cakeModel.cakeName,
            price: "$\(cakeModel.price)",
            discountedPrice: {
                guard let discountedPrice = cakeModel.discountedPrice else {
                    return nil
                }
                return "$\(discountedPrice)"
            }(),
            subtitle: cakeModel.seller.name,
            description: cakeModel.description,
            starsConfiguration: .basic(
                kind: .init(rawValue: Int(cakeModel.comments.averageRating)) ?? .zero,
                feedbackCount: cakeModel.comments.count
            )
        )
    }

    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration {
        return model.configureProductCard()
    }

}

#endif
