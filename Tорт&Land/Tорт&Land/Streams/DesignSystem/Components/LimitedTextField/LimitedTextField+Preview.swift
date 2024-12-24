//
//  LimitedTextField+Preview.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//

import SwiftUI

struct LimitedTextFieldPreview: View {

    @State private var text = ""

    var body: some View {
        Group {
            LimitedTextField(
                config: .init(limit: 80, tint: .secondary, autoResizes: true),
                hint: "Type here",
                value: $text
            )

            LimitedTextField(
                config: .init(limit: 80, tint: .secondary, autoResizes: true, progressConfig: .init(showsRing: false, showsText: true)),
                hint: "Type here",
                value: $text
            )
        }
        .frame(maxHeight: 150)
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    LimitedTextFieldPreview()
}
