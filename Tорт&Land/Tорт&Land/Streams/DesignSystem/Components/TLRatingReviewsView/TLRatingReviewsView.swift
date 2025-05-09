//
//  TLRatingReviewsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

/**
 Component `TLRatingReviewsView`

 For example:
 ```swift
 let view = TLRatingReviewsView(
     configuration: .basic(
         fiveStarRating: .basic(ration: .hundred, count: 12),
         fourStarRating: .basic(ration: .sixty, count: 5),
         threeStarRating: .basic(ration: .thirty, count: 4),
         twoStarRating: .basic(ration: .twenty, count: 2),
         oneStarRating: .basic(ration: .zero, count: 0),
         commontRating: "4.3",
         commontCount: "23 ratings"
     )
 )
 ```
*/
public struct TLRatingReviewsView: View, Configurable {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        HStack {
            VStack {
                Text(configuration.commontRating)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(TLColor<TextPalette>.textPrimary.color)

                Text(configuration.commentCount)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(TLColor<TextPalette>.textSecondary.color)
            }

            rightBlock
                .padding(.leading, 28)
        }
    }
}

private extension TLRatingReviewsView {

    var rightBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(configuration.counts) { counter in
                HStack {
                    HStack(spacing: 3) {
                        ForEach(0..<5-counter.id, id: \.self) { row in
                            Image(.starFill)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Constants.starSize)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(width: Constants.starSize * 5 + 12)

                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(TLColor<SeparatorPalette>.redLine.color)
                            .frame(width: geometry.size.width * counter.ration, height: 8)
                            .offset(y: geometry.size.height * 0.25)
                    }
                    .padding(.trailing, 28)

                    Text("\(counter.count)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(TLColor<TextPalette>.textSecondary.color)
                }
                .frame(maxWidth: .infinity, maxHeight: 14, alignment: .leading)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TLRatingReviewsView(
        configuration: .basic(
            fiveStarRating: .init(ration: .hundred, count: 9),
            fourStarRating: .init(ration: .sixty, count: 9),
            threeStarRating: .init(ration: .thirty, count: 6),
            twoStarRating: .init(ration: .twenty, count: 0),
            oneStarRating: .init(ration: .zero, count: 1),
            commonRating: "4.0",
            commonCount: "23 reviews"
        )
    )
    .padding(.horizontal)
}

// MARK: - Constants

private extension TLRatingReviewsView {
    enum Constants {
        static let starSize: CGFloat = 13
    }
}
