//
//  TLProductCard.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI
import Core

/**
Component `TLProductCard`

For example:
```swift
let view = TLProductCard(
    configuration: .constant(
        .basic(
            imageKind: .url(.mockProductCard),
            imageSize: CGSize(width: 148, height: 184),
            productText: .init(
                seller: "Mango Boy",
                productName: "T-Shirt Sailing",
                productPrice: "10$"
            ),
            productButtonConfiguration: .basic(kind: .favorite),
            starsViewConfiguration: .basic(kind: .four, feedbackCount: 8)
        )
    )
)
```
*/
public struct TLProductCard: View, Configurable {
    let configuration: Configuration
    var didTapButton: TLBoolBlock?

    public init(configuration: Configuration, didTapButton: TLBoolBlock? = nil) {
        self.configuration = configuration
        self.didTapButton = didTapButton
    }

    public var body: some View {
        VStack(alignment: .leading) {
            imageBlock
            footerBlockView
                .padding(.top, 2)
        }
        .contentShape(.rect)
    }
}

// MARK: - Subviews

private extension TLProductCard {

    var imageBlock: some View {
        TLImageView(configuration: configuration.imageConfiguration)
            .frame(height: configuration.imageHeight)
            .clipShape(.rect(cornerRadius: 9))
            .overlay(alignment: .topLeading) {
                if let badgeViewConfiguration = configuration.badgeViewConfiguration {
                    TLBadgeView(configuration: badgeViewConfiguration)
                        .padding([.top, .leading], 8)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                TLProductButton(
                    configuration: configuration.productButtonConfiguration,
                    didTapButton: didTapButton
                )
                .offset(x: 0, y: 18)
            }
    }

    var footerBlockView: some View {
        VStack(alignment: .leading) {
            startsBlockView
            if configuration.isShimmering {
                ShimmeringTextBlock
            } else {
                textBlockView
            }
        }
    }

    var startsBlockView: some View {
        TLStarsView(configuration: configuration.starsViewConfiguration)
    }

    var textBlockView: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let seller = configuration.productText.seller {
                Text(seller)
                    .style(11, .regular, Constants.sellerTextColor)
                    .lineLimit(1)
            }

            if let productName = configuration.productText.productName {
                Text(productName)
                    .style(16, .semibold, Constants.productNameColor)
                    .lineLimit(1)
            }

            if let discountedPrice = configuration.productText.productDiscountedPrice {
                HStack(spacing: 4) {
                    Text(configuration.productText.productPrice)
                        .style(14, .medium, Constants.oldPriceColor)
                        .strikethrough(true, color: Constants.oldPriceColor)

                    Text(discountedPrice)
                        .style(14, .medium, Constants.discountedPriceColor)
                }

            } else {
                Text(configuration.productText.productPrice)
                    .style(14, .medium, Constants.productNameColor)
            }
        }
    }

    var ShimmeringTextBlock: some View {
        VStack(alignment: .leading, spacing: 3) {
            Group {
                ShimmeringView()
                    .frame(width: 100, height: 8)

                ShimmeringView()
                    .frame(width: 130,  height: 12)

                ShimmeringView()
                    .frame(width: 40, height: 12)
            }
            .clipShape(.rect(cornerRadius: 7))
        }
    }
}

// MARK: - Preview

#Preview("Default") {
    VStack {
        TLProductCard(
            configuration: .basic(
                imageState: .fetched(.uiImage(TLPreviewAssets.cake1)),
                imageHeight: 184,
                productText: .init(
                    seller: "Mango Boy",
                    productName: "T-Shirt Sailing",
                    productPrice: "22$",
                    productDiscountedPrice: "10$"
                ),
                productButtonConfiguration: .basic(kind: .favorite()),
                starsViewConfiguration: .basic(kind: .four, feedbackCount: 20000)
            )
        )
        .frame(width: 148)
        
        TLProductCard(
            configuration: .shimmering(imageHeight: 184)
        )
        .frame(width: 148)
    }
}

// MARK: - Preview

#Preview("Shimmering") {
    TLProductCard(
        configuration: .shimmering(imageHeight: 184)
    )
    .frame(width: 148)
}

// MARK: - Constants

private extension TLProductCard {

    enum Constants {
        static let sellerTextColor: Color = TLColor<TextPalette>.textSecondary.color
        static let oldPriceColor: Color = TLColor<TextPalette>.textSecondary.color
        static let productNameColor: Color = TLColor<TextPalette>.textPrimary.color
        static let discountedPriceColor: Color = TLColor<TextPalette>.textWild.color
    }
}
