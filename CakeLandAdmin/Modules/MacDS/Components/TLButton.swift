//
//  TLButton.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import MacCore

public extension TLButton {
    struct Configuration: Hashable {
        var title: String
        var kind: Kind

        public init(title: String = "", kind: Kind = .default) {
            self.title = title
            self.kind = kind
        }
    }
}

public extension TLButton.Configuration {
    enum Kind: Hashable {
        case `default`
        case loading
    }
}

public struct TLButton: View, Configurable {
    var configuration = Configuration()
    var action: TLVoidBlock?
    @Environment(\.isEnabled) private var isEnabled

    public init(configuration: Configuration, action: TLVoidBlock? = nil) {
        self.configuration = configuration
        self.action = action
    }

    public init(_ title: String, action: TLVoidBlock? = nil) {
        configuration = Configuration(title: title)
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            content
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(TLButtonStyle(isEnabled: isEnabled))
    }

    @ViewBuilder
    private var content: some View {
        switch configuration.kind {
        case .default:
            Text(configuration.title)
                .style(14, .semibold, .white)
        case .loading:
            ProgressView()
                .controlSize(.small)
                .tint(.white)
        }
    }
}

private struct TLButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .background(Color.bgRed.opacity(isEnabled ? 1 : 0.4), in: .capsule)
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .animation(.spring, value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        Text("Просто текст")
        Text("Просто текст")
            .style(14, .semibold)
        TLButton("Save")
            .disabled(true)
        TLButton("Save")
            .frame(width: 180)
        TLButton(configuration: .init(title: "Save", kind: .loading))
        TLButton(configuration: .init())
    }
    .padding(.horizontal)
}
