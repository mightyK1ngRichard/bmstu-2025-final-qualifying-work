//
//  RatingReviewsViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Core
import Combine
import DesignSystem

@Observable
final class RatingReviewsViewModel: RatingReviewsDisplayLogic, RatingReviewsViewModelInput, RatingReviewsViewModelOutput {
    var uiProperties: RatingReviewsModel.UIProperties
    private(set) var comments: [CommentInfo] = []
    @ObservationIgnored
    private(set) var addFeedbackPublisher = PassthroughSubject<FeedbackEntity, Never>()
    @ObservationIgnored
    private let cakeID: String
    @ObservationIgnored
    private let reviewsService: ReviewsService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        cakeID: String,
        showFeedbackButton: Bool,
        reviewsService: ReviewsService,
        imageProvider: ImageLoaderProvider
    ) {
        uiProperties = RatingReviewsModel.UIProperties(showFeedbackButton: showFeedbackButton)
        self.cakeID = cakeID
        self.reviewsService = reviewsService
        self.imageProvider = imageProvider
    }
}

// MARK: - Network

extension RatingReviewsViewModel {

    func fetchComments() {
        uiProperties.state = .loading
        Task { @MainActor in
            do {
                let feedbacks = try await reviewsService.cakeFeedbacks(cakeID: cakeID)
                // Получаем изображения авторов
                var commentsInfo: [CommentInfo] = []
                commentsInfo.reserveCapacity(feedbacks.count)
                for (index, feedback) in feedbacks.enumerated() {
                    commentsInfo.append(CommentInfo(from: feedback))
                    fetchUserImage(index: index, urlString: feedback.author.imageURL)
                }

                comments = commentsInfo
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(content: error.readableGRPCContent)
            }
        }
    }

    private func fetchUserImage(index: Int, urlString: String?) {
        Task { @MainActor in
            guard let urlString else {
                comments[safe: index]?.author.imageState = .fetched(.uiImage(TLAssets.profile))
                return
            }

            let imageState = await imageProvider.fetchImage(for: urlString)
            comments[safe: index]?.author.imageState = imageState
        }
    }

}

// MARK: - Configurations

extension RatingReviewsViewModel {

    func configureReviewConfiguration() -> TLRatingReviewsView.Configuration {
        comments.ratingReviewsViewConfiguration
    }

    func configureCommentConfiguration(comment: CommentInfo) -> TLCommentView.Configuration {
        .basic(
            imageState: comment.author.imageState,
            userName: comment.author.name,
            date: comment.date,
            description: comment.description,
            starsConfiguration: .basic(
                kind: .init(rawValue: comment.countFillStars) ?? .zero
            )
        )
    }

    func openSheetView() -> FeedbackView {
        FeedbackAssembler.assemble(
            cakeID: cakeID,
            reviewsProvider: reviewsService,
            ratingReviewViewModel: self
        ) { [weak self] in
            self?.uiProperties.isOpenFeedbackView = false
        }
    }

    func configureErrorView(content: AlertContent) -> TLErrorView.Configuration {
        .init(from: content)
    }

}

// MARK: - Actions

extension RatingReviewsViewModel {

    func didTapWriteReviewButton() {
        uiProperties.isOpenFeedbackView = true
    }

}

// MARK: - RatingReviewsViewModelOutput

extension RatingReviewsViewModel {
    @MainActor
    func insertNewComment(_ feedback: FeedbackEntity) {
        let index = comments.count
        comments.append(CommentInfo(from: feedback))
        addFeedbackPublisher.send(feedback)
        fetchUserImage(index: index, urlString: feedback.author.imageURL)
    }
}

// MARK: - Setter

extension RatingReviewsViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
