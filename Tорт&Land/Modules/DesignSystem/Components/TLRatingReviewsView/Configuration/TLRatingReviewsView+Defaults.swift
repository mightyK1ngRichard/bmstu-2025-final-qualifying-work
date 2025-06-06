//
//  TLRatingReviewsView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import Foundation

extension TLRatingReviewsView.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - fiveStarRating: configuration of the five stars
    ///   - fourStarRating: configuration of the four stars
    ///   - threeStarRating: configuration of the three stars
    ///   - twoStarRating: configuration of the two stars
    ///   - oneStarRating: configuration of the one stars
    ///   - commonRating: average rating
    ///   - commonCount: count of the feedbacks
    /// - Returns: configuration of the view
    public static func basic(
        fiveStarRating: RatingData,
        fourStarRating: RatingData,
        threeStarRating: RatingData,
        twoStarRating: RatingData,
        oneStarRating: RatingData,
        commonRating: String,
        commonCount: String
    ) -> Self {
        .init(
            counts: [
                .init(id: 0, count: fiveStarRating.count, ration: fiveStarRating.ration.rawValue),
                .init(id: 1, count: fourStarRating.count, ration: fourStarRating.ration.rawValue),
                .init(id: 2, count: threeStarRating.count, ration: threeStarRating.ration.rawValue),
                .init(id: 3, count: twoStarRating.count, ration: twoStarRating.ration.rawValue),
                .init(id: 4, count: oneStarRating.count, ration: oneStarRating.ration.rawValue)
            ],
            commontRating: commonRating,
            commentCount: commonCount
        )
    }
}
