//
//  TLRatingReviewsView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import UIKit

public extension TLRatingReviewsView {
    struct Configuration: Hashable {
        var counts: [Rating] = []
        var commontRating = ""
        var commentCount = ""

        public init(
            counts: [Rating],
            commontRating: String = "",
            commentCount: String = ""
        ) {
            self.counts = counts
            self.commontRating = commontRating
            self.commentCount = commentCount
        }
    }
}

// MARK: - RatingData

public extension TLRatingReviewsView.Configuration {
    /// Input data
    struct RatingData: Hashable {
        let ration: Kind
        let count: Int

        public init(ration: Kind, count: Int) {
            self.ration = ration
            self.count = count
        }
    }
    
    /// Ration kind
    enum Kind: CGFloat, Hashable {
        case zero = 0
        case ten = 0.1
        case twenty = 0.2
        case thirty = 0.3
        case forty = 0.4
        case fifty = 0.5
        case sixty = 0.6
        case seventy = 0.7
        case eighty = 0.8
        case ninety = 0.9
        case hundred = 1
    }
}

public extension TLRatingReviewsView {
    struct Rating: Identifiable, Hashable {
        public let id: Int
        let count: Int
        let ration: CGFloat

        public init(id: Int, count: Int, ration: CGFloat) {
            self.id = id
            self.count = count
            self.ration = ration
        }
    }
}
