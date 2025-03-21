//
//  CakeDetailsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

protocol CakeDetailsDisplayData {
    var cakeModel: CakeModel { get }
    var isOwnedByUser: Bool { get }
}

protocol CakeDetailsViewModelInput {
    func fetchCakeDetails(cakeUID: String)

    func setEnvironmentObjects(coordinator: Coordinator)
    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration
    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration
    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration
    func assemblyRatingReviewsView() -> RatingReviewsView

    func didTapSellerInfoButton()
    func didTapRatingReviewsButton()
    func didTapBackButton()
    func didTapSimilarCake(model: CakeModel)
    func didTapCakeLike(model: CakeModel, isSelected: Bool)
}

protocol CakeDetailsViewModelOutput {
}
