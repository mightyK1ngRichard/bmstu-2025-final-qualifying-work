//
//  AddressEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//

import Foundation

public struct AddressEntity: Sendable {
    /// Код адреса
    public let id: String
    /// Широта
    public let latitude: Double
    /// Долгота
    public let longitude: Double
    /// Форматированный адрес
    public let formattedAddress: String
    /// Подъезд
    public let entrance: String?
    /// Этаж
    public let floor: String?
    /// Квартира
    public let apartment: String?
    /// Комментарий к доставке
    public let comment: String?
}

// MARK: - Profile_Address

extension AddressEntity {
    init(from model: Profile_Address) {
        self = AddressEntity(
            id: model.id,
            latitude: model.latitude,
            longitude: model.longitude,
            formattedAddress: model.formattedAddress,
            entrance: model.hasEntrance ? model.entrance : nil,
            floor: model.hasFloor ? model.floor : nil,
            apartment: model.hasApartment ? model.apartment : nil,
            comment: model.hasComment ? model.comment : nil
        )
    }
}
