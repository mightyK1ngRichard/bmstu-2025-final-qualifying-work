//
//  ProductCardWorker.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

final class ProductCardWorker {
    func configureProductCard(model: CakeModel, section: CakesListModel.Section) -> TLProductCard.Configuration {
        let badgeViewConfiguration: TLBadgeView.Configuration? = {
            let text: String
            let kind: TLBadgeView.Configuration.Kind
            switch section {
            case .new:
                text = "NEW"
                kind = .dark
            case .sale:
                guard let discountedPrice = model.discountedPrice else {
                    return nil
                }
                let discountPercentage = (discountedPrice * 100) / model.price
                text = "-\(Int(round(discountPercentage)))%"
                kind = .red
            case .all:
                return nil
            }

            return .basic(text: text, kind: kind)
        }()
        let productDiscountedPrice: String? = {
            guard let discountedPrice = model.discountedPrice else {
                return nil
            }
            return "\(discountedPrice)$"
        }()

        return .basic(
            imageState: model.thumbnails.first?.imageState ?? .empty,
            imageHeight: 184,
            productText: .init(
                seller: model.seller.name,
                productName: model.cakeName,
                productPrice: "\(model.price)$",
                productDiscountedPrice: productDiscountedPrice
            ),
            badgeViewConfiguration: badgeViewConfiguration,
            productButtonConfiguration: .basic(kind: .favorite(isSelected: model.isSelected))
        )
    }
}
