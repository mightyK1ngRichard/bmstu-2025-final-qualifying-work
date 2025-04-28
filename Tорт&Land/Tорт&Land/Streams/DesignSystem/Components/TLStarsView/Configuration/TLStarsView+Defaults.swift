//
//  TLStarsView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

extension TLStarsView.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - kind: count of the fill stars
    ///   - feedbackCount: count of the feedback
    /// - Returns: configuration of the view
    static func basic(
        kind: Kind,
        feedbackCount: Int? = nil
    ) -> Self {
        .init(
            countFillStars: kind.rawValue,
            starWidth: Constants.starWidth,
            padding: Constants.padding,
            feedbackCount: feedbackCount,
            foregroundColor: Constants.foregroundColor,
            lineHeigth: Constants.lineHeigth,
            leftPadding: Constants.leftPadding,
            isShimmering: false
        )
    }

    static var shimmering: Self {
        .init(
            countFillStars: Kind.five.rawValue,
            starWidth: Constants.starWidth,
            padding: Constants.padding,
            isShimmering: true
        )
    }

    static var shimmeringInverted: Self {
        .init(
            countFillStars: Kind.five.rawValue,
            starWidth: Constants.starWidth,
            padding: Constants.padding,
            isShimmering: true,
            shimmeringKind: .inverted
        )
    }
}

// MARK: - Constants

private extension TLStarsView.Configuration {

    enum Constants {
        static let starWidth: CGFloat = 13
        static let padding: CGFloat = 2
        static let lineHeigth: CGFloat = 10
        static let leftPadding: CGFloat = 4
        static let foregroundColor = TLColor<IconPalette>.iconSecondary.color
    }
}
