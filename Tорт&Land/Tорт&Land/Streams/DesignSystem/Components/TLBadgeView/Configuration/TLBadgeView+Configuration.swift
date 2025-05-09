//
//  TLBadgeView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import SwiftUI

public extension TLBadgeView {

    struct Configuration: Hashable {
        var text = ""
        var backgroundColor: Color = .clear
        var foregroundColor: Color = .clear
        var backgroundEdges: EdgeInsets = .init()
        var cornerRadius: CGFloat = .zero
        var fontSize: CGFloat = .zero
    }
}

// MARK: - Kind

public extension TLBadgeView.Configuration {

    /// Kind of the background color
    enum Kind {
        case dark
        case red
    }
}

extension TLBadgeView.Configuration.Kind {

    var backgroundColor: Color {
        switch self {
        case .dark:
            return TLColor<BackgroundPalette>.bgDark.color
        case .red:
            return TLColor<BackgroundPalette>.bgRed.color
        }
    }
}
