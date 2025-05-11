//
//  TLStarsView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import SwiftUICore

public extension TLStarsView {

    struct Configuration: Hashable {
        /// Count of the fill star
        var countFillStars: Int = .zero
        /// Width of the star
        var starWidth: CGFloat = .zero
        /// Padding between stars
        var padding: CGFloat = .zero
        /// Count of the feedback
        var feedbackCount: Int?
        /// Color of the text
        var foregroundColor: Color = .clear
        /// Text line heigth
        var lineHeigth: CGFloat = .zero
        /// Padding between text and stars
        var leftPadding: CGFloat = .zero
        /// Shimmering flag
        var isShimmering: Bool = false
        /// Shimmering kind
        var shimmeringKind: ShimmeringView.ShimmeringKind = .default

        public init(
            countFillStars: Int = .zero,
            starWidth: CGFloat = .zero,
            padding: CGFloat = .zero,
            feedbackCount: Int? = nil,
            foregroundColor: Color = .clear,
            lineHeigth: CGFloat = .zero,
            leftPadding: CGFloat = .zero,
            isShimmering: Bool = false,
            shimmeringKind: ShimmeringView.ShimmeringKind = .default
        ) {
            self.countFillStars = countFillStars
            self.starWidth = starWidth
            self.padding = padding
            self.feedbackCount = feedbackCount
            self.foregroundColor = foregroundColor
            self.lineHeigth = lineHeigth
            self.leftPadding = leftPadding
            self.isShimmering = isShimmering
            self.shimmeringKind = shimmeringKind
        }
    }
}

// MARK: - Kind

public extension TLStarsView.Configuration {

    /// Kind of stars block
    enum Kind: Int {
        case zero = 0
        case one
        case two
        case three
        case four
        case five
    }
}
