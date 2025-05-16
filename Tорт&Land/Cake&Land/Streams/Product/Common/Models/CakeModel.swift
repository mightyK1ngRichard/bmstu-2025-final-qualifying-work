//
//  CakeModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import DesignSystem
import Core

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
    /// Масса торта (в граммах)
    var mass: Double
    /// Цена со скидкой (если есть)
    var discountedPrice: Double?
    /// Рейтинг торта (от 0 до 5)
    var rating: Int
    /// Число отзывов
    var reviewsCount: Int
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
    /// Hex цвета торта
    var colorsHex: [String]
    /// Ссылка на 3Д модель
    var model3DURL: String?
    /// Статус торта
    var status: CakeStatus
    /// Корректный URL 3D модели
    var model3DURLProd: URL? {
        guard let modelString = model3DURL, let url = URL(string: modelString.replaceLocalhost()) else {
            return nil
        }

        return url
    }
}

// MARK: - CakeStatus

/// Статусы торта
public enum CakeStatus: Hashable {
    /// Не указано
    case unspecified
    /// Ожидает
    case pending
    /// Одобрено и открыто для продажи/
    case approved
    /// Отказано
    case rejected
    /// Скрыто
    case hidden
}

// MARK: - Proto

extension CakeModel {
    init(from model: ProfilePreviewCakeEntity) {
        self = CakeModel(
            id: model.id,
            previewImageState: .loading,
            thumbnails: [],
            cakeName: model.name,
            price: model.kgPrice,
            mass: model.mass,
            discountedPrice: {
                guard let discountKgPrice = model.discountKgPrice else {
                    return nil
                }

                return model.discountEndTime < Date.now ? nil : discountKgPrice
            }(),
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            isSelected: false,
            description: model.description ?? "",
            establishmentDate: model.dateCreation.description,
            similarCakes: [],
            comments: [],
            categories: [],
            fillings: [],
            seller: UserModel(from: model.owner),
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL,
            status: CakeStatus(from: model.status)
        )
    }

    init(from model: CakeEntity) {
        self = CakeModel(
            id: model.id,
            previewImageState: .loading,
            thumbnails: model.images.map {
                Thumbnail(id: $0.id, imageState: .loading, url: $0.imageURL)
            },
            cakeName: model.name,
            price: model.kgPrice,
            mass: model.mass,
            discountedPrice: {
                guard let discountKgPrice = model.discountKgPrice, let discountEndTime = model.discountEndTime else {
                    return nil
                }

                return discountEndTime < Date.now ? nil : discountKgPrice
            }(),
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            isSelected: false,
            description: model.description,
            establishmentDate: model.dateCreation.description,
            similarCakes: [],
            comments: [],
            categories: model.categories.map(Category.init(from:)),
            fillings: model.fillings.map(Filling.init(from:)),
            seller: UserModel(from: model.owner),
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL,
            status: CakeStatus(from: model.status)
        )
    }
}

extension CakeStatus {
    init(from model: CakeStatusEntity) {
        switch model {
        case .unspecified:
            self = .unspecified
        case .pending:
            self = .pending
        case .approved:
            self = .approved
        case .rejected:
            self = .rejected
        case .hidden:
            self = .hidden
        }
    }

    var toProto: CakeStatusEntity {
        switch self {
        case .unspecified:
            return .unspecified
        case .pending:
            return .pending
        case .approved:
            return .approved
        case .rejected:
            return .rejected
        case .hidden:
            return .hidden
        }
    }
}

// MARK: - PreviewCakeEntity

extension CakeModel {

    init(from model: PreviewCakeEntity) {
        // 1000 ₽/кг * 2 кг = 2000 ₽
        let cakePrice = model.kgPrice
        let discountedPrice: Double? = {
            guard let discount = model.discountKgPrice, let discountEndTime = model.discountEndTime else {
                return nil
            }
            return discountEndTime < Date.now ? nil : discount
        }()

        self = CakeModel(
            id: model.id,
            previewImageState: .loading,
            thumbnails: [],
            cakeName: model.name,
            price: cakePrice,
            mass: model.mass,
            discountedPrice: discountedPrice,
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            isSelected: false,
            description: model.description,
            establishmentDate: model.dateCreation.description,
            similarCakes: [],
            comments: [],
            categories: model.categories.map(Category.init(from:)),
            fillings: model.fillings.map(Filling.init(from:)),
            seller: UserModel(from: model.owner),
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL,
            status: CakeStatus(from: model.status)
        )
    }

    func applyDetails(_ cakeEntity: CakeEntity) -> CakeModel {
        var cakeCopy = self
        cakeCopy.thumbnails = cakeEntity.images.map { Thumbnail(id: $0.id, imageState: .loading, url: $0.imageURL) }
        cakeCopy.categories = cakeEntity.categories.map(Category.init(from:))
        cakeCopy.fillings = cakeEntity.fillings.map(Filling.init(from:))
        cakeCopy.status = CakeStatus(from: cakeEntity.status)
        return cakeCopy
    }
}

// MARK: - TLProductCard

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
                seller: seller.fio ?? seller.nickname,
                productName: cakeName,
                productPrice: priceFormatter.formatPrice(price),
                productDiscountedPrice: productDiscountedPrice
            ),
            disableText: status == .approved ? nil : "Sorry, this item is currently closed for sale",
            badgeViewConfiguration: badgeViewConfiguration,
            productButtonConfiguration: .basic(kind: .favorite(isSelected: isSelected)),
            starsViewConfiguration: starsConfiguration()
        )
    }

    func configureProductHCard(priceFormatter: PriceFormatterService) -> TLProductHCard.Configuration {
        let discountedPriceLabel: String? = {
            guard let discountedPrice else {
                return nil
            }

            return priceFormatter.formatKgPrice(discountedPrice)
        }()
        let kgPriceLabel = discountedPriceLabel == nil ? priceFormatter.formatKgPrice(price) : priceFormatter.formatPrice(price)

        return .init(
            imageConfiguration: .init(imageState: previewImageState),
            starsConfiguration: starsConfiguration(),
            seller: seller.fio ?? seller.nickname,
            title: cakeName,
            productPrice: kgPriceLabel,
            mass: "\(Int(mass))г.",
            productDiscountedPrice: discountedPriceLabel
        )
    }

}

// MARK: - Helpers

extension CakeModel {

    func starsConfiguration() -> TLStarsView.Configuration {
        .basic(
            kind: .init(rawValue: rating) ?? .zero,
            feedbackCount: reviewsCount
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
        let discountPercentage = 100 - (discountedPrice * 100) / price
        return ("-\(Int(discountPercentage))%", .red)
    }

}

// MARK: - TLProductDescriptionView Configuration

extension CakeModel {

    func configureDescriptionView(priceFormatter: PriceFormatterService) -> TLProductDescriptionView.Configuration {
        .basic(
            title: "\(cakeName), \(Int(mass))г",
            price: priceFormatter.formatPrice(price),
            discountedPrice: {
                guard let discountedPrice else {
                    return nil
                }
                return priceFormatter.formatPrice(discountedPrice)
            }(),
            subtitle: seller.titleName,
            description: description,
            starsConfiguration: starsConfiguration()
        )
    }
}
