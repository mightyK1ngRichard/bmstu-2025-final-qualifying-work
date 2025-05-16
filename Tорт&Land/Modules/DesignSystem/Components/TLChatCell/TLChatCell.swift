//
//  TLChatCell.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import Core

/**
 Component `TLChatCell`

 For example:
 ```swift
 let view = TLChatCell(
     configuration: .basic(
         imageState: .fetched(.uiImage(.user2)),
         title: "Dmitriy Permyakov",
         subtitle: "Hello, VK! It is CakesHub application",
         time: "02:10"
     )
 )
 ```
*/
public struct TLChatCell: View, Configurable {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 15) {
            TLImageView(configuration: configuration.imageConfiguration)
                .frame(width: 60, height: 60)
                .clipShape(.circle)

            if configuration.isShimmering {
                shimmeringTextContainer
            } else {
                textContainer
            }
        }
        .contentShape(.rect)
    }
}

// MARK: - UI Subviews

private extension TLChatCell {
    @ViewBuilder
    var textContainer: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(configuration.title)
                    .style(20, .semibold, TLColor<TextPalette>.textPrimary.color)
                    .lineLimit(1)

                Text(configuration.subtitle)
                    .style(16, .regular, TLColor<TextPalette>.textSecondary.color)
                    .lineLimit(1)
            }

            Spacer(minLength: 2)

            if let time = configuration.time {
                Text(time)
                    .style(13, .medium, TLColor<TextPalette>.textSecondary.color)
            }
        }
    }

    var shimmeringTextContainer: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                shimmeringView(width: 150, height: 20)
                shimmeringView(width: 200, height: 16)
            }
            Spacer(minLength: 2)

            shimmeringView(width: 35, height: 13)
        }
    }

    func shimmeringView(width: CGFloat, height: CGFloat) -> some View {
        ShimmeringView()
            .frame(width: width, height: height)
            .clipShape(.capsule)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        TLChatCell(
            configuration: .basic(
                imageState: .fetched(.uiImage(TLAssets.profile)),
                title: "Dmitriy Permyakov",
                subtitle: "Hello, VK! It is CakesHub application",
                time: "02:10"
            )
        )

        TLChatCell(
            configuration: .shimmering
        )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(.bar)
}
