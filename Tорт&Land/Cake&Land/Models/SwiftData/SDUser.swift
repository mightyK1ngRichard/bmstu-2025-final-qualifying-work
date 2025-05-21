//
//  SDUser.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 19.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftData

@Model
final class SDUser: Networkable {
    /// ID пользователя
    @Attribute(.unique)
    var userID: String
    /// Полное имя
    var fio: String?
    /// Никнейм
    var nickname: String
    /// Электронная почта
    var mail: String
    /// Аватар пользователя
    var imageURL: String?
    /// Шапка профиля
    var headerImageURL: String?

    @Relationship(deleteRule: .cascade, inverse: \SDCake.owner)
    var cakes: [SDCake] = []

    init(
        userID: String,
        fio: String?,
        nickname: String,
        mail: String,
        imageURL: String?,
        headerImageURL: String?
    ) {
        self.userID = userID
        self.fio = fio
        self.nickname = nickname
        self.mail = mail
        self.imageURL = imageURL
        self.headerImageURL = headerImageURL
    }
}

// MARK: - UserEntity

extension SDUser {
    convenience init(from model: UserEntity) {
        self.init(
            userID: model.id,
            fio: model.fio,
            nickname: model.nickname,
            mail: model.mail,
            imageURL: model.imageURL,
            headerImageURL: model.headerImageURL
        )
    }

    var asEntity: UserEntity {
        UserEntity(
            id: userID,
            fio: fio,
            nickname: nickname,
            mail: mail,
            imageURL: imageURL,
            headerImageURL: headerImageURL
        )
    }

    func update(with newEntity: UserEntity) {
        guard newEntity.id == userID else {
            return
        }

        fio = newEntity.fio
        nickname = newEntity.nickname
        mail = newEntity.mail
        imageURL = newEntity.imageURL
        headerImageURL = newEntity.headerImageURL
    }
}
