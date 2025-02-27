//
//  TLProductButton+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

extension TLProductButton.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - kind: icon style
    /// - Returns: configuration of the view
    static func basic(kind: Kind) -> Self {
        .init(
            backgroundColor: kind.backgroundColor,
            buttonSize: Constants.buttonSize,
            iconSize: Constants.iconSize,
            shadowColor: kind.shadowColor,
            kind: kind
        )
    }

    static var shimmering: Self {
        .init(
            buttonSize: Constants.buttonSize,
            isShimmering: true
        )
    }
}

// MARK: - Constants

private extension TLProductButton.Configuration {

    enum Constants {
        static let buttonSize: CGFloat = 36
        static let iconSize: CGFloat = 12
    }
}
