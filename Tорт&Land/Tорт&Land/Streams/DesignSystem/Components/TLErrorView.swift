//
//  TLErrorView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 20.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension TLErrorView {
    struct Configuration: Hashable {
        var kind: Kind = .noConnection
    }
}

extension TLErrorView.Configuration {
    enum Kind: Hashable {
        case noConnection
        case customError(String, String)
    }
}

extension TLErrorView.Configuration.Kind {
    var title: String {
        switch self {
        case .noConnection:
            return "No connection"
        case let .customError(title, _):
            return title
        }
    }

    var subtitle: String {
        switch self {
        case .noConnection:
            return "Ooops.. Looks like connection has been lost"
        case let .customError(_, subtitle):
            return subtitle
        }
    }
}

struct TLErrorView: View {
    var configuration: Configuration
    var action: TLVoidBlock?

    var body: some View {
        VStack(spacing: 40) {
            Image(.noConnection)
                .resizable()
                .scaledToFit()

            VStack(spacing: 24) {
                Text(configuration.kind.title)
                    .style(24, .medium)
                Text(configuration.kind.subtitle)
                    .style(16, .regular, TLColor<TextPalette>.textSecondary.color)
                    .multilineTextAlignment(.center)

                Button {
                    action?()
                } label: {
                    Text("Try again")
                        .style(16, .medium, .white)
                        .frame(height: 40)
                        .padding(.horizontal, 43)
                }
                .background(
                    TLColor<TextPalette>(hexLight: 0x66C3E8, hexDark: 0x66C3E8).color,
                    in: .capsule
                )
            }
        }
    }
}

#Preview {
    TLErrorView(configuration: .init())
        .padding(.horizontal, 53)
}
