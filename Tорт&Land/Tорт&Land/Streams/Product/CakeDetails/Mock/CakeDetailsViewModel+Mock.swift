//
//  CakeDetailsViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

#if DEBUG

import Foundation

final class CakeDetailsViewModelMock: CakeDetailsDisplayData & CakeDetailsViewModelInput {
    var bindingData: CakeDetailsModel.BindingData
    private(set) var showOwnerButton: Bool
    private(set) var cakeModel: CakeModel
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        bindingData: CakeDetailsModel.BindingData = .init(),
        isOwnedByUser: Bool,
        cakeModel: CakeModel = CommonMockData.generateMockCakeModel(id: 23)
    ) {
        self.bindingData = bindingData
        self.showOwnerButton = !isOwnedByUser
        self.cakeModel = cakeModel
    }

    func fetchCakeDetails() {

    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func didTapSellerInfoButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.addScreen(RootModel.Screens.profile(cakeModel.seller))
    }

    func didTapRatingReviewsButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.addScreen(CakeDetailsModel.Screens.ratingReviews)
    }

    func didTapBackButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.openPreviousScreen()
    }

    func didTapSimilarCake(model: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(model))
    }

    func didTapCakeLike(model: CakeModel, isSelected: Bool) {}

    func fetchCakeDetails(cakeUID: String) {}
}

// MARK: - Configure

extension CakeDetailsViewModelMock {
    func assemblyRatingReviewsView() -> RatingReviewsView {
        let viewModel = RatingReviewsViewModelMock(comments: cakeModel.comments)
        return RatingReviewsView(viewModel: viewModel)
    }

    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration {
        .init(imageState: thumbnail.imageState)
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        cakeModel.configureDescriptionView()
    }

    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration {
        model.configureProductCard()
    }
}

#endif
