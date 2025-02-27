//
//  RatingReviewsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol RatingReviewsDisplayLogic: RatingReviewsViewModelInput {
    var uiProperties: RatingReviewsModel.UIProperties { get set }
    var comments: [CommentInfo] { get }
}

protocol RatingReviewsViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureReviewConfiguration() -> TLRatingReviewsView.Configuration
    func configureCommentConfiguration(comment: CommentInfo) -> TLCommentView.Configuration
    func openSheetView() -> FeedbackView
}

protocol RatingReviewsViewModelOutput {
    func didTapWriteReviewButton()
}
