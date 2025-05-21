//
//  RatingReviewsAssemler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class RatingReviewsAssembler {
    static func assemble(
        cakeID: String,
        showFeedbackButton: Bool,
        reviewsService: ReviewsService,
        imageProvider: ImageLoaderProvider
    ) -> RatingReviewsView {
        let viewModel = RatingReviewsViewModel(
            cakeID: cakeID,
            showFeedbackButton: showFeedbackButton,
            reviewsService: reviewsService,
            imageProvider: imageProvider
        )
        return RatingReviewsView(viewModel: viewModel)
    }
}
