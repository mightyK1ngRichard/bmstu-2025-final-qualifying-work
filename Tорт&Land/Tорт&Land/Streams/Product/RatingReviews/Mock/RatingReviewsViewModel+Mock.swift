//
//  RatingReviewsViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class RatingReviewsViewModelMock: RatingReviewsDisplayLogic & RatingReviewsViewModelOutput {
    var uiProperties = RatingReviewsModel.UIProperties()
    private(set) var data: ProductReviewsModel = MockData.mockProductReviewsModel
    private(set) var countOfComments = 0

    func setEnvironmentObjects(coordinator: Coordinator) {}

    func openSheetView() -> FeedbackView {
        FeedbackView(viewModel: FeedbackViewModelMock())
    }

    func configureReviewConfiguration() -> TLRatingReviewsView.Configuration {
        data.reviewConfiguration
    }

    func didTapWriteReviewButton() {
        uiProperties.isOpenFeedbackView = true
    }

    func configureCommentConfiguration(comment: ProductReviewsModel.CommentInfo) -> TLCommentView.Configuration {
        .basic(
            imageState: .fetched(.uiImage(.mockUser)),
            userName: comment.userName,
            date: comment.date,
            description: comment.description,
            starsConfiguration: .basic(
                kind: .init(rawValue: comment.countFillStars) ?? .zero
            )
        )
    }
}

// MARK: - Constants

private extension RatingReviewsViewModelMock {
    enum MockData {
        static let mockProductReviewsModel = ProductReviewsModel(
            countFiveStars: 12,
            countFourStars: 5,
            countThreeStars: 4,
            countTwoStars: 2,
            countOneStars: 0,
            countOfComments: mockCommentsInfo.count,
            comments: mockCommentsInfo
        )
        static let mockCommentsInfo = (0...10).map { generateMockCommentInfo($0) }
        static func generateMockCommentInfo(_ number: Int) -> ProductReviewsModel.CommentInfo {
            ProductReviewsModel.CommentInfo(
                id: String(number),
                userName: "Helene Moore \(number)",
                date: "June 5, 2019",
                description: """
                The dress is great! Very classy and comfortable. It fit perfectly! I'm 5'7" and 130 pounds. I am a 34B chest. This dress would be too long for those who are shorter but could be hemmed. I wouldn't recommend it for those big chested as I am smaller chested and it fit me perfectly. The underarms were not too wide and the dress was made well.
                """,
                countFillStars: number % 6
            )
        }
    }
}
#endif
