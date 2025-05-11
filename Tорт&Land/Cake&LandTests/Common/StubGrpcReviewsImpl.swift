//
//  StubGrpcReviewsImpl.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 25.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
@testable import NetworkAPI

final class StubGrpcReviewsImpl: ReviewsService {
    func cakeFeedbacks(cakeID: String) async throws -> [NetworkAPI.FeedbackEntity] {
        fatalError("No implementation")
    }

    func createFeedback(request: NetworkAPI.ReviewsServiceModel.CreateFeedback.Request) async throws -> NetworkAPI.ReviewsServiceModel.CreateFeedback.Response {
        fatalError("No implementation")
    }
}
