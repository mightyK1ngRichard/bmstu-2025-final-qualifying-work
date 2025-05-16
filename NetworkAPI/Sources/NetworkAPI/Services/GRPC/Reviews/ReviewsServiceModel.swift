//
//  ReviewsServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 22.04.2025.
//

import Foundation

public enum ReviewsServiceModel {
    public enum CreateFeedback {}
}

// MARK: - CreateFeedback

public extension ReviewsServiceModel.CreateFeedback {
    struct Request: Sendable {
        let cakeID: String
        let text: String
        let rating: Int

        public init(
            cakeID: String,
            text: String,
            rating: Int
        ) {
            self.cakeID = cakeID
            self.text = text
            self.rating = rating
        }
    }

    struct Response: Sendable {
        public var feedback: FeedbackEntity
    }
}
