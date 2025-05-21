//
//  TLProductDescriptionView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

public extension TLProductDescriptionView {

    struct Configuration {
        /// Product title
        var title: String = ""
        /// Product price
        var price: String = ""
        /// Product discounted price
        var discountedPrice: String?
        /// Product subtitle
        var subtitle: String = ""
        /// Product description
        var description: String = ""
        /// View horizonral padding
        var innerHPadding: CGFloat = .zero
        /// Configurations of the stars
        var starsConfiguration: TLStarsView.Configuration = .init()
        /// Shimmering flag
        var isShimmering = false
    }
}

// MARK: - PickerItem

public extension TLProductDescriptionView.Configuration {

    struct PickerItem: Identifiable {
        public let id: Int
        let title: String
    }
}
