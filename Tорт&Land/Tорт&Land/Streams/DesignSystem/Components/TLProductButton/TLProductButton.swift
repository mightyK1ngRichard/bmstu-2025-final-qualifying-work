//
//  TLProductButton.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import SwiftUI

/**
Component `TLProductButton`

For example:
```swift
let view = TLProductButton(
    configuration: .basic(kind: .basket)
)
```
*/
struct TLProductButton: View, Configurable {
    let configuration: Configuration
    var didTapButton: TLBoolBlock?
    @State private var isSelected: Bool

    init(
        configuration: Configuration,
        didTapButton: TLBoolBlock? = nil
    ) {
        self.configuration = configuration
        self.didTapButton = didTapButton
        self.isSelected = configuration.kind.isSelected
    }

    var body: some View {
        if configuration.isShimmering {
            ShimmeringView()
                .frame(width: configuration.buttonSize, height: configuration.buttonSize)
                .clipShape(.circle)
        } else {
            mainContainer
                .contentShape(.circle)
                .onTapGesture {
                    isSelected.toggle()
                    didTapButton?(isSelected)
                }
        }
    }
}

// MARK: - Private Subviews

private extension TLProductButton {

    var mainContainer: some View {
        ZStack {
            Circle()
                .fill(configuration.backgroundColor)
                .frame(width: configuration.buttonSize, height: configuration.buttonSize)

            if let image = configuration.kind.iconImage(isSelected: isSelected) {
                image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: configuration.iconSize)
                    .foregroundStyle(
                        configuration.kind.iconColor(iconIsSelected: isSelected)
                    )
            }
        }
        .shadow(color: configuration.shadowColor, radius: 10)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        TLProductButton(
            configuration: .basic(kind: .favorite(isSelected: true))
        )
        TLProductButton(
            configuration: .basic(kind: .basket)
        )
    }
}
