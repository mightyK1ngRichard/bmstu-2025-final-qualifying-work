//
//  FeedbackAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftUICore
import Core
import NetworkAPI

final class FeedbackAssembler {
    static func assemble(
        cakeID: String,
        reviewsProvider: ReviewsService,
        ratingReviewViewModel: RatingReviewsViewModelOutput,
        dismiss: @escaping TLVoidBlock
    ) -> FeedbackView {
        let viewModel = FeedbackViewModel(
            cakeID: cakeID,
            reviewsProvider: reviewsProvider,
            ratingReviewViewModel: ratingReviewViewModel,
            dismiss: dismiss
        )
        return FeedbackView(viewModel: viewModel)
    }
}
