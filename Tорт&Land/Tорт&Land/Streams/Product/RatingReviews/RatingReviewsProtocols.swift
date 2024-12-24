//
//  RatingReviewsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

import Foundation

protocol RatingReviewsDisplayLogic: RatingReviewsViewModelInput {
    var uiProperties: RatingReviewsModel.UIProperties { get set }
    var countOfComments: Int { get }
    var data: ProductReviewsModel { get }
}

protocol RatingReviewsViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureReviewConfiguration() -> TLRatingReviewsView.Configuration
    func configureCommentConfiguration(comment: ProductReviewsModel.CommentInfo) -> TLCommentView.Configuration
    func openSheetView() -> FeedbackView
}

protocol RatingReviewsViewModelOutput {
    func didTapWriteReviewButton()
}
