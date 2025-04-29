//
//  ProductReviewsModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//

import Foundation
import NetworkAPI

struct CommentInfo: Identifiable, Hashable {
    /// Код комментария
    var id: String
    /// Автор коментария
    var author: Author
    /// Дата комментария
    var date: String
    /// Описание комментария
    var description: String
    /// Число закрашенных звёзд (от 1 до 5)
    var countFillStars: Int
}

extension CommentInfo {
    init(from model: FeedbackEntity) {
        self = CommentInfo(
            id: model.id,
            author: CommentInfo.Author(from: model.author),
            date: model.dateCreation.formattedHHmm,
            description: model.text,
            countFillStars: model.rating
        )
    }
}

// MARK: - Author

extension CommentInfo {
    struct Author: Hashable {
        /// Код автора
        var id: String
        /// Имя автора
        var name: String
        /// Фотография автора
        var imageState: ImageState
    }
}

extension CommentInfo.Author {
    init(from model: ProfileEntity) {
        self = .init(
            id: model.id,
            name: model.fio ?? model.nickname,
            imageState: .loading
        )
    }
}

// MARK: - Helpers

extension [CommentInfo] {
    
    /// Готовая конфигурация для `TLRatingReviewsView`
    var ratingReviewsViewConfiguration: TLRatingReviewsView.Configuration {
        // Считаем, сколько звёзд для 1, для 2, ..., для 5
        // Число звёзд:     1  2  3  4  5
        var stars: [Int] = [0, 0, 0, 0, 0]
        /// Счётчик, сколько всего звёзд
        var allStarsCount = 0
        /// Число корректных отзывов
        var feedbackCount = 0
        self.forEach { comment in
            if comment.countFillStars <= 5 && comment.countFillStars > 0 {
                stars[comment.countFillStars - 1] += 1
                allStarsCount += comment.countFillStars
                feedbackCount += 1
            }
        }
        let maxStar = Swift.max(stars[4], stars[3], stars[2], stars[1], stars[0])

        let assemleConfiguration: (Int) -> TLRatingReviewsView.Configuration.RatingData = { number in
            let perсentArea = CGFloat(number) / CGFloat(maxStar)
            return .init(
                ration: TLRatingReviewsView.Configuration.Kind(rawValue: (perсentArea).rounded(toPlaces: 1)) ?? .zero,
                count: number
            )
        }

        /// Среднее число звёзд
        var averageRating: CGFloat {
            guard feedbackCount > 0 else { return .zero }
            return CGFloat(allStarsCount) / CGFloat(feedbackCount)
        }

        return .basic(
            fiveStarRating: assemleConfiguration(stars[4]),
            fourStarRating: assemleConfiguration(stars[3]),
            threeStarRating: assemleConfiguration(stars[2]),
            twoStarRating: assemleConfiguration(stars[1]),
            oneStarRating: assemleConfiguration(stars[0]),
            commonRating: "\(averageRating.rounded(toPlaces: 1))",
            commonCount: String(localized: "ratings") + ": \(feedbackCount)"
        )
    }

    /// Среднее число звёзд
    var averageRating: CGFloat {
        var allStarsCount = 0
        var feedbackCount = 0
        self.forEach {
            allStarsCount += $0.countFillStars
            feedbackCount += 1
        }
        guard feedbackCount > 0 else { return .zero }
        return CGFloat(allStarsCount) / CGFloat(feedbackCount)
    }

}
