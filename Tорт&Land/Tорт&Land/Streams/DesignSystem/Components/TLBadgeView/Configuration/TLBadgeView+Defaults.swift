//
//  TLBadgeView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

extension TLBadgeView.Configuration {

    static func basic(
        text: String,
        kind: Kind = .red
    ) -> Self {
        .init(
            text: text,
            backgroundColor: kind.backgroundColor,
            foregroundColor: .white,
            backgroundEdges: Constants.backgroundEdges,
            cornerRadius: Constants.cornerRadius,
            fontSize: Constants.fontSize
        )
    }
}

// MARK: - Constants

private extension TLBadgeView.Configuration {

    enum Constants {
        static let cornerRadius: CGFloat = 29
        static let fontSize: CGFloat = 11
        static let backgroundEdges = EdgeInsets(top: 7, leading: 6, bottom: 6, trailing: 6)
    }
}

