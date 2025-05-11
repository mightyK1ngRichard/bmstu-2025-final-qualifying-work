//
//  TLProductCard+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import Core

public extension TLProductCard.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - imageKind: Image kind
    ///   - imageHeight: Image height
    ///   - productText: Product info
    ///   - badgeViewConfiguration: Badge info
    ///   - productButtonConfiguration: Product button info
    ///   - starsViewConfiguration: Product rating
    /// - Returns: Configuration of the view
    static func basic(
        imageState: ImageState,
        imageHeight: CGFloat,
        productText: ProductText,
        disableText: String? = nil,
        badgeViewConfiguration: TLBadgeView.Configuration? = nil,
        productButtonConfiguration: TLProductButton.Configuration = .init(),
        starsViewConfiguration: TLStarsView.Configuration = .init()
    ) -> Self {
        .init(
            imageConfiguration: .init(imageState: imageState),
            badgeViewConfiguration: badgeViewConfiguration,
            imageHeight: imageHeight,
            productButtonConfiguration: productButtonConfiguration,
            starsViewConfiguration: starsViewConfiguration,
            productText: productText,
            disableText: disableText
        )
    }

    static func shimmering(imageHeight: CGFloat) -> Self {
        .init(
            imageConfiguration: .init(imageState: .loading),
            imageHeight: imageHeight,
            starsViewConfiguration: .shimmering
        )
    }
}
