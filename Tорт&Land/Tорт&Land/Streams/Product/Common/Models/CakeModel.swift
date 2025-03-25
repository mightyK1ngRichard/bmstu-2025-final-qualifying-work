//
//  CakeModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

struct CakeModel: Identifiable, Hashable {
    /// Код торта
    let id: String
    /// Изображение карточки товара
    var previewImageState: ImageState
    /// Состояние изображений
    var thumbnails: [Thumbnail]
    /// Название торта
    var cakeName: String
    /// Цена торта (без скидки)
    var price: Double
    /// Цена со скидкой (если есть)
    var discountedPrice: Double?
    /// Рейтинг торта (от 0 до 5)
    var rating: Int
    /// Флаг любимого товара
    var isSelected: Bool
    /// Описание товара
    var description: String
    /// Дата создания товара
    var establishmentDate: String
    /// Схожие товары
    var similarCakes: [CakeModel]
    /// Комментарии
    var comments: [CommentInfo]
    /// Категории торта
    var categories: [Category]
    /// Начинки торта
    var fillings: [Filling]
    /// Продовец
    var seller: UserModel
}

// MARK: - PreviewCakeEntity

extension CakeModel {

    init(from model: PreviewCakeEntity) {
        // 1000 ₽/кг * 2 кг = 2000 ₽
        let cakePrice = model.kgPrice * model.mass
        let discountedPrice: Double? = {
            guard let discount = model.discountKgPrice else {
                return nil
            }
            return discount * model.mass
        }()

        self = CakeModel(
            id: model.id,
            previewImageState: .loading,
            thumbnails: [],
            cakeName: model.name,
            price: cakePrice,
            discountedPrice: discountedPrice,
            rating: model.rating,
            isSelected: false,
            description: model.description,
            establishmentDate: model.dateCreation.description,
            similarCakes: [],
            comments: [],
            categories: [],
            fillings: [],
            seller: UserModel(
                id: model.owner.id,
                name: model.owner.fio ?? StringConstants.anonimeUserName,
                mail: model.owner.mail,
                avatarImage: .empty,
                headerImage: .empty,
                cakes: []
            )
        )
    }

    func applyDetails(_ cakeEntity: CakeEntity) -> CakeModel {
        var cakeCopy = self
        cakeCopy.thumbnails = cakeEntity.images.map { Thumbnail(id: $0.id, imageState: .loading, url: $0.imageURL) }
        cakeCopy.categories = cakeEntity.categories.map(Category.init(from:))
        cakeCopy.fillings = cakeEntity.fillings.map(Filling.init(from:))
        return cakeCopy
    }
}

// MARK: - TLProductCard Configuration

extension CakeModel {

    func configureProductCard(priceFormatter: PriceFormatterService) -> TLProductCard.Configuration {
        let badgeViewConfiguration: TLBadgeView.Configuration? = {
            let (badgeText, badgeKind) = badgeInfo
            guard let badgeText, let badgeKind else {
                return nil
            }
            return .basic(text: badgeText, kind: badgeKind)
        }()
        let productDiscountedPrice: String? = {
            guard let discountedPrice else {
                return nil
            }
            return priceFormatter.formatPrice(discountedPrice)
        }()

        return .basic(
            imageState: previewImageState,
            imageHeight: 184,
            productText: .init(
                seller: seller.name,
                productName: cakeName,
                productPrice: priceFormatter.formatPrice(price),
                productDiscountedPrice: productDiscountedPrice
            ),
            badgeViewConfiguration: badgeViewConfiguration,
            productButtonConfiguration: .basic(kind: .favorite(isSelected: isSelected)),
            starsViewConfiguration: starsConfiguration
        )
    }

    var starsConfiguration: TLStarsView.Configuration {
        .basic(
            kind: .init(rawValue: rating) ?? .zero,
            feedbackCount: comments.count
        )
    }

    private var isNew: Bool {
        guard let productDate = establishmentDate.dateRedescription else {
            return false
        }

        let componentsDif = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: productDate,
            to: Date.now
        )
        guard componentsDif.month == 0 && componentsDif.year == 0 else {
            return false
        }

        // Получаем разницу нынешней даты и даты создания объявления
        guard let difDay = componentsDif.day else {
            return false
        }

        // Если разница меньше 8, объявление считается новым
        return difDay < 8
    }

    private var badgeInfo: (String?, TLBadgeView.Configuration.Kind?) {
        guard let discountedPrice else {
            if isNew {
                return ("NEW", .dark)
            }
            return (nil, nil)
        }
        let discountPercentage = (discountedPrice * 100) / price
        return ("-\(Int(round(discountPercentage)))%", .red)
    }
}

// MARK: - TLProductDescriptionView Configuration

extension CakeModel {

    func configureDescriptionView(priceFormatter: PriceFormatterService) -> TLProductDescriptionView.Configuration {
        .basic(
            title: cakeName,
            price: priceFormatter.formatPrice(price),
            discountedPrice: {
                guard let discountedPrice else {
                    return nil
                }
                return priceFormatter.formatPrice(discountedPrice)
            }(),
            subtitle: seller.name,
            description: description,
            starsConfiguration: starsConfiguration
        )
    }
}
