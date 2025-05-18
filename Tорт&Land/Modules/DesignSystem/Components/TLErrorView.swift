//
//  TLErrorView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 20.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import Core

public extension TLErrorView {
    struct Configuration: Hashable {
        var kind: Kind = .noConnection
        var buttonTitle: String

        public init(
            kind: Kind = .noConnection,
            buttonTitle: String = String(localized: "Try again")
        ) {
            self.kind = kind
            self.buttonTitle = buttonTitle
        }
    }
}

public extension TLErrorView.Configuration {
    enum Kind: Hashable {
        case noConnection
        case customError(String, String)
    }
}

public extension TLErrorView.Configuration.Kind {
    var title: String {
        switch self {
        case .noConnection:
            return String(localized: "No connection")
        case let .customError(title, _):
            return title
        }
    }

    var subtitle: String {
        switch self {
        case .noConnection:
            return String(localized: "Ooops.. Looks like connection has been lost")
        case let .customError(_, subtitle):
            return subtitle
        }
    }
}

public struct TLErrorView: View, Configurable {
    var configuration = Configuration()
    var action: TLVoidBlock?

    public init(configuration: Configuration = Configuration(), action: TLVoidBlock? = nil) {
        self.configuration = configuration
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 40) {
            Image(uiImage: TLAssets.noConnection)
                .resizable()
                .scaledToFit()

            VStack(spacing: 24) {
                Text(configuration.kind.title)
                    .style(24, .medium)
                Text(configuration.kind.subtitle)
                    .style(16, .regular, TLColor<TextPalette>.textSecondary.color)
                    .multilineTextAlignment(.center)

                TLButton(configuration.buttonTitle, action: action)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TLErrorView()
        .padding(.horizontal, 53)
}
