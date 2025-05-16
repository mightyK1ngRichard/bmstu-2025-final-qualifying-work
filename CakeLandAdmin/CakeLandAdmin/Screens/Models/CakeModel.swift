//
//  CakeModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation
import NetworkAPI
import SwiftUI

struct CakeModel: Identifiable, Hashable {
    /// Код торта
    let id: String
    /// Изображение карточки товара
    var previewImage: Thumbnail
    /// Состояние изображений
    var thumbnails: [Thumbnail]
    /// Название торта
    var cakeName: String
    /// Цена торта (без скидки)
    var kgPrice: Double
    /// Масса торта (в граммах)
    var mass: Double
    /// Цена со скидкой (если есть)
    var discountedKgPrice: Double?
    /// Дата окончания скидки
    var discountedEndDate: Date?
    /// Рейтинг торта (от 0 до 5)
    var rating: Int
    /// Число отзывов
    var reviewsCount: Int
    /// Описание товара
    var description: String
    /// Дата создания товара
    var establishmentDate: Date
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
}

// MARK: - CakeStatus

enum CakeStatus: Hashable, CaseIterable {
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

extension CakeStatus {
    var title: String {
        switch self {
        case .approved:
            return "Одобрено"
        case .pending:
            return "Ожидает"
        case .rejected:
            return "Отказано"
        case .hidden:
            return "Скрыто"
        case .unspecified:
            return "Не указано"
        }
    }

    var textColor: Color {
        switch self {
        case .approved:
            return .green
        case .pending:
            return .orange
        case .rejected:
            return .red
        case .hidden:
            return .gray
        case .unspecified:
            return .black
        }
    }
}

// MARK: - Proto

extension CakeModel {
    init(from model: CakeEntity) {
        self = CakeModel(
            id: model.id,
            previewImage: Thumbnail(url: model.imageURL),
            thumbnails: model.images.map {
                Thumbnail(id: $0.id, imageState: .loading, url: $0.imageURL)
            },
            cakeName: model.name,
            kgPrice: model.kgPrice,
            mass: model.mass,
            discountedKgPrice: {
                guard let discountKgPrice = model.discountKgPrice, let discountEndTime = model.discountEndTime else {
                    return nil
                }

                return discountEndTime < Date.now ? nil : discountKgPrice
            }(),
            discountedEndDate: model.discountEndTime,
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            description: model.description,
            establishmentDate: model.dateCreation,
            categories: model.categories.map(Category.init(from:)),
            fillings: model.fillings.map(Filling.init(from:)),
            seller: UserModel(from: model.owner),
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL,
            status: CakeStatus(from: model.status)
        )
    }

    init(from model: PreviewCakeEntity) {
        self = CakeModel(
            id: model.id,
            previewImage: Thumbnail(url: model.imageURL),
            thumbnails: [],
            cakeName: model.name,
            kgPrice: model.kgPrice,
            mass: model.mass,
            discountedKgPrice: {
                guard let discountKgPrice = model.discountKgPrice, let discountEndTime = model.discountEndTime else {
                    return nil
                }

                return discountEndTime < Date.now ? nil : discountKgPrice
            }(),
            discountedEndDate: model.discountEndTime,
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            description: model.description,
            establishmentDate: model.dateCreation,
            categories: model.categories.map(Category.init(from:)),
            fillings: model.fillings.map(Filling.init(from:)),
            seller: UserModel(from: model.owner),
            colorsHex: model.colorsHex,
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
