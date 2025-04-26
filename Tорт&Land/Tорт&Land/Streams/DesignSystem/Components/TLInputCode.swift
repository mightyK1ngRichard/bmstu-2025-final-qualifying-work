//
//  TLInputCode.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

// MARK: - Configuration

extension TLInputCode {
    struct Configuration: Hashable {
        var title: String?
        var placeholder = ""
        var vPaddings: CGFloat {
            title == nil ? 22 : 14
        }
    }
}

// MARK: - TLInputCode

struct TLInputCode: View {
    var configuration = Configuration()
    @Binding var inputText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = configuration.title {
                Text(title)
                    .style(11, .regular)
            }

            TextField(configuration.placeholder, text: $inputText)
        }
        .padding(.vertical, configuration.vPaddings)
        .padding(.horizontal, 20)
        .background(TLColor<BackgroundPalette>.bgTextField.color, in: .rect(cornerRadius: 4))
    }
}

// MARK: - Preview

#Preview {
    VStack {
        TLInputCode(
            configuration: .init(title: "State/Province/Region", placeholder: "Input text"),
            inputText: .constant("Chino Hills")
        )

        TLInputCode(
            configuration: .init(placeholder: "Input text"),
            inputText: .constant("Chino Hills")
        )
    }
    .padding()
}
