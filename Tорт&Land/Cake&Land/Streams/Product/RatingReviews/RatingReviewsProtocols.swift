//
//  RatingReviewsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import DesignSystem
import Combine

protocol RatingReviewsDisplayLogic {
    var uiProperties: RatingReviewsModel.UIProperties { get set }
    var comments: [CommentInfo] { get }
}

protocol RatingReviewsViewModelInput {
    func configureReviewConfiguration() -> TLRatingReviewsView.Configuration
    func configureCommentConfiguration(comment: CommentInfo) -> TLCommentView.Configuration
    func configureErrorView(content: ErrorContent) -> TLErrorView.Configuration
    func openSheetView() -> FeedbackView

    func fetchComments()
    func didTapWriteReviewButton()
    func setEnvironmentObjects(coordinator: Coordinator)
}

protocol RatingReviewsViewModelOutput {
    @MainActor
    func insertNewComment(_ feedback: FeedbackEntity)
    var addFeedbackPublisher: PassthroughSubject<FeedbackEntity, Never> { get }
}
