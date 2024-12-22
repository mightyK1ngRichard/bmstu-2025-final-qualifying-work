//
//  CakeDetailsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

protocol CakeDetailsDisplayLogic: CakeDetailsViewModelInput {
    var cakeModel: CakeDetailsModel.CakeModel { get }
    var isOwnedByUser: Bool { get }
    var currentUser: CakeDetailsModel.UserModel { get }
}

protocol CakeDetailsViewModelInput {
    func configureImageViewConfiguration(for imageState: ImageState) -> TLImageView.Configuration
    func configureSimilarProductConfiguration(for model: CakeDetailsModel.CakeModel) -> TLProductCard.Configuration
    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration
}

protocol CakeDetailsViewModelOutput {
    func didTapSellerInfoButton()
    func didTapRatingReviewsButton()
    func didTapBackButton()
}
