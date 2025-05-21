//
//  TLProductDescriptionView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import SwiftUI

/**
 Component `TLProductDescriptionView`

 For example:
 ```swift
 let view = TLProductDescriptionView(
     configuration: .basic(
         title: "H&M",
         price: "$19.99",
         subtitle: "Short black dress",
         description: "Просто описание",
         starsConfiguration: .basic(kind: .five, feedbackCount: 10)
     )
 )
 ```
*/
public struct TLProductDescriptionView: View {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View  {
        VStack(alignment: .leading) {
            textBlock
                .padding(.horizontal, configuration.innerHPadding)

            starsBlock
                .padding(.horizontal, configuration.innerHPadding)

            if !configuration.description.isEmpty {
                descriptionBlock
                    .padding(.horizontal, configuration.innerHPadding)
                    .padding(.top, 16)
            }
        }
    }
}

// MARK: - Subviews

private extension TLProductDescriptionView {

    var textBlock: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(configuration.title)
                    .titleFont

                Text(configuration.subtitle)
                    .subtitleFont
            }

            Spacer()

            if let discountedPrice = configuration.discountedPrice {
                VStack(alignment: .trailing) {
                    Text(discountedPrice)
                        .style(24, .semibold, TLColor<TextPalette>.textWild.color)

                    Text(configuration.price)
                        .style(16, .semibold, TLColor<TextPalette>.textSecondary.color)
                        .strikethrough(true, color: TLColor<TextPalette>.textSecondary.color)
                }
            } else {
                Text(configuration.price)
                    .titleFont
            }
        }
    }

    var starsBlock: some View {
        TLStarsView(configuration: configuration.starsConfiguration)
    }

    var descriptionBlock: some View {
        Text(configuration.description)
            .descriptionFont
    }
}

// MARK: - Preview

#Preview {
    TLProductDescriptionView(
        configuration: .basic(
            title: "Просто очень большой текст кототйы не влезает",
            price: "$19.99",
            discountedPrice: "$12.22",
            subtitle: "Short black dress",
            description: "Просто описание",
            starsConfiguration: .basic(kind: .five, feedbackCount: 10)
        )
    )
}

// MARK: - Text

private extension Text {

    var titleFont: some View {
        font(.system(size: 24, weight: .semibold))
            .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
    }

    var subtitleFont: some View {
        font(.system(size: 11, weight: .regular))
            .foregroundStyle(TLColor<TextPalette>.textSecondary.color)
    }

    var descriptionFont: some View {
        font(.system(size: 14, weight: .regular))
            .foregroundStyle(TLColor<TextPalette>.textSecondary.color)
            .lineSpacing(6)
    }
}
