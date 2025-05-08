//
//  TLProductHCard.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension TLProductHCard {
    struct Configuration: Hashable {
        var imageConfiguration: TLImageView.Configuration = .init()
        var starsConfiguration: TLStarsView.Configuration = .init()
        var seller = ""
        var title = ""
        var productPrice = ""
        var mass = ""
        var productDiscountedPrice: String?
        var isShimmering = false

        static var shimmering: Configuration {
            .init(isShimmering: true)
        }
    }
}

struct TLProductHCard: View, Configurable {
    var configuration = Configuration()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if configuration.isShimmering {
                shimmeringContainer
            } else {
                productContainer
            }
        }
        .frame(height: 104)
        .background(TLColor<BackgroundPalette>.bgTextField.color)
        .clipShape(.rect(cornerRadius: 8))
    }
}

// MARK: - UI Subviews

private extension TLProductHCard {

    @ViewBuilder
    var productContainer: some View {
        imageContainer
        textContainer
    }

    var shimmeringContainer: some View {
        HStack(spacing: 0) {
            ShimmeringView(kind: .inverted)
                .frame(width: 104)

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading) {
                        shimmeringView
                            .frame(width: 80, height: 9)
                        shimmeringView
                            .frame(width: 100, height: 14)
                    }

                    shimmeringView
                        .frame(width: 40, height: 9)
                }

                HStack {
                    shimmeringView
                        .frame(width: 60, height: 17)
                    Spacer()
                    TLStarsView(configuration: .shimmeringInverted)
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(11)
        }
    }

    var shimmeringView: some View {
        ShimmeringView(kind: .inverted)
            .clipShape(.capsule)
    }

    var imageContainer: some View {
        TLImageView(configuration: configuration.imageConfiguration)
            .frame(width: 104)
    }

    var textContainer: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 6) {
                sellerAndTilteContainer
                massContainer
            }
            Spacer()
            HStack {
                priceContainer
                Spacer()
                TLStarsView(configuration: configuration.starsConfiguration)
            }
        }
        .padding(11)
    }

    var sellerAndTilteContainer: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(configuration.seller)
                .style(11, .regular, Constants.sellerTextColor)
                .lineLimit(1)

            Text(configuration.title)
                .style(16, .semibold)
        }
    }

    var massContainer: some View {
        Text(configuration.mass)
            .style(11, .regular, Constants.sellerTextColor)
    }

    @ViewBuilder
    var priceContainer: some View {
        if let discountedPrice = configuration.productDiscountedPrice {
            HStack(spacing: 4) {
                Text(configuration.productPrice)
                    .style(14, .medium, Constants.oldPriceColor)
                    .strikethrough(true, color: Constants.oldPriceColor)

                Text(discountedPrice)
                    .style(14, .medium, Constants.discountedPriceColor)
            }

        } else {
            Text(configuration.productPrice)
                .style(14, .medium, Constants.productNameColor)
        }
    }

}

// MARK: - Preview

#Preview {
    ZStack {
        TLColor<BackgroundPalette>.bgMainColor.color

        VStack {
            TLProductHCard(
                configuration: .shimmering
            )

            TLProductHCard(
                configuration: .init(
                    imageConfiguration: .init(imageState: .fetched(.uiImage(.cake1))),
                    starsConfiguration: .basic(kind: .five, feedbackCount: 100),
                    seller: "Пермяков Дмитрий",
                    title: "Просто вкусный тортик",
                    productPrice: "100$",
                    mass: "1000г",
                    productDiscountedPrice: "80$"
                )
            )

            TLProductHCard(
                configuration: .init(
                    imageConfiguration: .init(imageState: .fetched(.uiImage(.cake1))),
                    starsConfiguration: .basic(kind: .five, feedbackCount: 100),
                    seller: "Пермяков Дмитрий",
                    title: "Просто вкусный тортик",
                    productPrice: "100$",
                    mass: "1000г"
                )
            )
        }
        .padding()
    }
}

// MARK: - Constants

private extension TLProductHCard {

    enum Constants {
        static let sellerTextColor: Color = TLColor<TextPalette>.textSecondary.color
        static let oldPriceColor: Color = TLColor<TextPalette>.textSecondary.color
        static let productNameColor: Color = TLColor<TextPalette>.textPrimary.color
        static let discountedPriceColor: Color = TLColor<TextPalette>.textWild.color
    }
}

