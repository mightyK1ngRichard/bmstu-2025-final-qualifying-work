//
//  TLBadgeView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

/**
Component `TLBadgeView`

For example:
```swift
let badgeView = TLBadgeView(
    configuration: .basic(text: "50%")
)
```
*/
public struct TLBadgeView: View, Configurable {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        Text(configuration.text)
            .font(
                .system(size: configuration.fontSize, weight: .semibold, design: .rounded)
            )
            .padding(configuration.backgroundEdges)
            .background(configuration.backgroundColor)
            .clipShape(.rect(cornerRadius: configuration.cornerRadius))
            .foregroundStyle(configuration.foregroundColor)
    }
}

// MARK: - Preview

#Preview {
    TLBadgeView(configuration: .basic(text: "50%"))
}
