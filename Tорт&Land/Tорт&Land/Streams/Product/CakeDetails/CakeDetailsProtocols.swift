//
//  CakeDetailsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

protocol CakeDetailsDisplayLogic: CakeDetailsViewModelInput {
    var cakeModel: CakeModel { get }
    var isOwnedByUser: Bool { get }
    var currentUser: UserModel { get }
}

protocol CakeDetailsViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration
    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration
    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration
    func assemblyRatingReviewsView() -> RatingReviewsView
}

protocol CakeDetailsViewModelOutput {
    func didTapSellerInfoButton()
    func didTapRatingReviewsButton()
    func didTapBackButton()
    func didTapSimilarCake(model: CakeModel)
    func didTapCakeLike(model: CakeModel, isSelected: Bool)
}
