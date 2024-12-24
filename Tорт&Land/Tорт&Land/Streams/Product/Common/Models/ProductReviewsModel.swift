//
//  ProductReviewsModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//

import Foundation

struct ProductReviewsModel {
    var countFiveStars = 0
    var countFourStars = 0
    var countThreeStars = 0
    var countTwoStars = 0
    var countOneStars = 0
    var countOfComments = 0
    var comments: [CommentInfo] = []
    var feedbackCount = 0
}

// MARK: - CommentInfo

extension ProductReviewsModel {

    struct CommentInfo: Identifiable {
        var id = ""
        var userName = ""
        var date = ""
        var description = ""
        var countFillStars = 0
    }
}

// MARK: - Calculation values

extension ProductReviewsModel {

    var reviewConfiguration: TLRatingReviewsView.Configuration {
        let maxStar = max(countFiveStars, countFourStars, countThreeStars, countTwoStars, countOneStars)
        let assemleConfiguration: (Int) -> TLRatingReviewsView.Configuration.RatingData = { number in
            let perсentArea = CGFloat(number) / CGFloat(maxStar)
            return .init(
                ration: TLRatingReviewsView.Configuration.Kind(rawValue: (perсentArea).rounded(toPlaces: 1)) ?? .zero,
                count: number
            )
        }

        return TLRatingReviewsView.Configuration.basic(
            fiveStarRating: assemleConfiguration(countFiveStars),
            fourStarRating: assemleConfiguration(countFourStars),
            threeStarRating: assemleConfiguration(countThreeStars),
            twoStarRating: assemleConfiguration(countTwoStars),
            oneStarRating: assemleConfiguration(countOneStars),
            commonRating: averageRatingString,
            commonCount: String(localized: "ratings") + ": \(feedbackCount)"
        )
    }

    private var feedbackAmountOfPoints: Int {
        countFiveStars * 5 + countFourStars * 4 + countThreeStars * 3 + countTwoStars * 2 + countOneStars
    }
    private var averageRatingString: String {
        return "\(averageRating.rounded(toPlaces: 1))"
    }
    var averageRating: CGFloat {
        guard feedbackCount > 0 else { return .zero }
        return CGFloat(feedbackAmountOfPoints) / CGFloat(feedbackCount)
    }
}

// MARK: - Inner logic

private extension ProductReviewsModel {

    func calculateRatingConfiguration(_ count: Int) -> TLRatingReviewsView.Configuration.RatingData {
        let perсentArea = CGFloat(count) / CGFloat(feedbackCount)
        let ration = TLRatingReviewsView.Configuration.Kind(rawValue: perсentArea.rounded(toPlaces: 1)) ?? .zero
        let configuration = TLRatingReviewsView.Configuration.RatingData.init(ration: ration, count: count)
        return configuration
    }
}
