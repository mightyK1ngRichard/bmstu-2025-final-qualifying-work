//
//  FeedbackViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftUICore
import Core

@Observable
final class FeedbackViewModel: FeedbackDisplayLogic, FeedbackViewModelInput {
    var uiProperties = FeedbackModel.UIProperties()
    private var dismiss: TLVoidBlock
    @ObservationIgnored
    private let cakeID: String
    @ObservationIgnored
    private let reviewsProvider: ReviewsService
    @ObservationIgnored
    private let ratingReviewViewModel: RatingReviewsViewModelOutput

    init(
        cakeID: String,
        reviewsProvider: ReviewsService,
        ratingReviewViewModel: RatingReviewsViewModelOutput,
        dismiss: @escaping TLVoidBlock
    ) {
        self.cakeID = cakeID
        self.dismiss = dismiss
        self.reviewsProvider = reviewsProvider
        self.ratingReviewViewModel = ratingReviewViewModel
    }
}

extension FeedbackViewModel {

    func didTapSendFeedbackButton() {
        guard uiProperties.countFillStars > 0 && uiProperties.countFillStars < 6 else {
            showErrorMessage(
                content: AlertContent(
                    title: StringConstants.invalidInputData,
                    message: StringConstants.chooseRating.capitalized
                )
            )
            return
        }
        guard !uiProperties.feedbackText.isEmpty else {
            showErrorMessage(
                content: AlertContent(
                    title: StringConstants.invalidInputData,
                    message: StringConstants.textCannotBeEmpty
                )
            )
            return
        }

        uiProperties.isLoading = true
        Task { @MainActor in
            do {
                let response = try await reviewsProvider.createFeedback(
                    request: .init(
                        cakeID: cakeID,
                        text: uiProperties.feedbackText,
                        rating: uiProperties.countFillStars
                    )
                )
                ratingReviewViewModel.insertNewComment(response.feedback)
                dismiss()
            } catch {
                showErrorMessage(content: error.readableGRPCContent)
            }

            uiProperties.isLoading = false
        }
    }

    func didTapStar(count: Int) {
        uiProperties.countFillStars = count
    }

    func didTapCloseErrorAlert() {
        uiProperties.alert = .init()
    }

    private func showErrorMessage(content: AlertContent) {
        uiProperties.alert = AlertModel(
            content: content,
            isShown: true
        )
    }
}
