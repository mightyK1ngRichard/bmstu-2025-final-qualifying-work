//
//  TLStarsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

/**
Component `TLStarsView`

For example:
```swift
let view = TLStarsView(
    configuration: .basic(kind: .two, feedbackCount: 10)
)
```
*/
public struct TLStarsView: View, Configurable {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: configuration.leftPadding) {
            HStack(spacing: configuration.padding) {
                ForEach(0..<configuration.countFillStars, id: \.self) { _ in
                    if configuration.isShimmering {
                        ShimmeringView(kind: configuration.shimmeringKind)
                            .frame(width: configuration.starWidth, height: configuration.starWidth)
                            .mask {
                                Image(.starFill)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: configuration.starWidth)
                            }
                    } else {
                        Image(.starFill)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: configuration.starWidth)
                    }
                }

                ForEach(0..<5-configuration.countFillStars, id: \.self) { _ in
                    Image(.starOutline)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: configuration.starWidth)
                }
            }

            if let text = configuration.feedbackCount {
                Text("(\(text))")
                    .font(.system(size: configuration.lineHeigth, weight: .regular))
                    .foregroundStyle(configuration.foregroundColor)
            }
        }
    }
}

// MARK: - Preview

#Preview("Shimmering") {
    TLStarsView(configuration: .shimmering)
}

#Preview("Default") {
    TLStarsView(configuration: .basic(kind: .two, feedbackCount: 10))
}
