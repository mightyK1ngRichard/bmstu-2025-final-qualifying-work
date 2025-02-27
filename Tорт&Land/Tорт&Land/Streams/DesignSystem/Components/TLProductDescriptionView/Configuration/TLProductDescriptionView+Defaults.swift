//
//  TLProductDescriptionView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

extension TLProductDescriptionView.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - title: product name
    ///   - price: product price
    ///   - subtitle: product seller
    ///   - description: product description
    ///   - innerHPadding: horizontal paddings
    ///   - starsConfiguration: stars configuration
    /// - Returns: configuration of the view
    static func basic(
        title: String,
        price: String,
        discountedPrice: String? = nil,
        subtitle: String,
        description: String,
        innerHPadding: CGFloat = 16,
        starsConfiguration: TLStarsView.Configuration
    ) -> Self {
        .init(
            title: title,
            price: price,
            discountedPrice: discountedPrice,
            subtitle: subtitle,
            description: description,
            innerHPadding: innerHPadding,
            starsConfiguration: starsConfiguration
        )
    }
}
