//
//  ProfileEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 09.04.2025.
//

public struct ProfileEntity: Sendable, Hashable {
    public let id: String
    public let fio: String?
    public let address: String?
    public let nickname: String
    public let imageUrl: String?
    public let headerImageUrl: String?
    public let mail: String
    public let phone: String?
    public let cardNumber: String?
}

extension ProfileEntity {
    init(from model: Profile_Profile) {
        self = ProfileEntity(
            id: model.id,
            fio: model.hasFio ? model.fio.value : nil,
            address: model.hasAddress ? model.address.value : nil,
            nickname: model.nickname,
            imageUrl: model.hasImageURL ? model.imageURL.value : nil,
            headerImageUrl: model.hasHeaderImageURL ? model.headerImageURL.value : nil,
            mail: model.mail,
            phone: model.hasPhone ? model.phone.value : nil,
            cardNumber: model.hasCardNumber ? model.cardNumber.value : nil
        )
    }
}
