//
//  TLButton.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension TLButton {
    struct Configuration: Hashable {
        var title = ""
        var kind: Kind = .default
    }
}

extension TLButton.Configuration {
    enum Kind: Hashable {
        case `default`
        case loading
    }
}

struct TLButton: View {
    let configuration: Configuration
    var action: TLVoidBlock?
    @Environment(\.isEnabled) private var isEnabled

    init(configuration: Configuration, action: TLVoidBlock? = nil) {
        self.configuration = configuration
        self.action = action
    }

    init(_ title: String, action: TLVoidBlock? = nil) {
        configuration = Configuration(title: title)
        self.action = action
    }

    var body: some View {
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
                .style(14, .medium, .white)
        case .loading:
            ProgressView()
                .tint(.white)
        }
    }
}

private struct TLButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 14)
            .background(TLColor<BackgroundPalette>.bgRed.color.opacity(isEnabled ? 1 : 0.4))
            .clipShape(.rect(cornerRadius: 25))
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .animation(.spring, value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        TLButton("Save")
            .disabled(true)
        TLButton("Save")
        TLButton(configuration: .init(title: "Save", kind: .loading))
        TLButton(configuration: .init())
    }
    .padding(.horizontal)
}
