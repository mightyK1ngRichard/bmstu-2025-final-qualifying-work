//
//  TLProductCard+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import SwiftUI

public extension TLProductCard {

    struct Configuration: Hashable {
        /// Configuration of the image view
        var imageConfiguration: TLImageView.Configuration = .init()
        /// Configuration of the badge view
        var badgeViewConfiguration: TLBadgeView.Configuration?
        /// Height of the image view
        var imageHeight: CGFloat = .zero
        /// Configuration of the product info
        var productButtonConfiguration: TLProductButton.Configuration = .init()
        /// Configuration of the product rating
        var starsViewConfiguration: TLStarsView.Configuration = .init()
        /// Product info
        var productText: ProductText = .init()
        /// Disable text
        var disableText: String?
    }
}

// MARK: - ProductText

public extension TLProductCard.Configuration {

    struct ProductText: Hashable {
        var seller: String?
        var productName: String?
        var productPrice: String
        var productDiscountedPrice: String?

        public init(
            seller: String? = nil,
            productName: String? = nil,
            productPrice: String = "",
            productDiscountedPrice: String? = nil
        ) {
            self.seller = seller
            self.productName = productName
            self.productPrice = productPrice
            self.productDiscountedPrice = productDiscountedPrice
        }
    }
}

// MARK: - Shimmering

public extension TLProductCard.Configuration {

    var isShimmering: Bool {
        productButtonConfiguration.isShimmering || starsViewConfiguration.isShimmering
    }
}
