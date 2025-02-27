//
//  TLRatingReviewsView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import UIKit

extension TLRatingReviewsView {
    struct Configuration: Hashable {
        var counts: [Rating] = []
        var commontRating = ""
        var commentCount = ""
    }
}

// MARK: - RatingData

extension TLRatingReviewsView.Configuration {
    /// Input data
    struct RatingData: Hashable {
        let ration: Kind
        let count: Int
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

extension TLRatingReviewsView {
    struct Rating: Identifiable, Hashable {
        let id: Int
        let count: Int
        let ration: CGFloat
    }
}
