//
//  UserModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Core

struct UserModel: Identifiable, Hashable {
    /// Код пользователя
    var id: String
    /// ФИО пользователя
    var fio: String?
    /// Псевдоним пользователя
    var nickname: String
    /// Аватарка пользователя
    var avatarImage: Thumbnail
    /// Шапка пользователя
    var headerImage: Thumbnail
    /// Почта пользователя
    var mail: String
    /// Телефон пользователя
    var phone: String?
    /// Номер карты пользователя
    var cardNumber: String?
    /// Продавайемые торты пользователя
    var cakes: [CakeModel]

    var titleName: String {
        fio ?? nickname
    }
}

extension UserModel {
    init(from model: UserInfoEntity) {
        let user = model.profile

        self = UserModel(
            id: user.id,
            fio: user.fio,
            nickname: user.nickname,
            avatarImage: Thumbnail(id: UUID().uuidString, imageState: .loading, url: model.profile.imageURL),
            headerImage: Thumbnail(id: UUID().uuidString, imageState: .loading, url: model.profile.headerImageURL),
            mail: user.mail,
            phone: user.phone,
            cakes: model.previewCakes.map(CakeModel.init(from:))
        )
    }

    init(from model: UserEntity) {
        self = UserModel(
            id: model.id,
            fio: model.fio,
            nickname: model.nickname,
            avatarImage: Thumbnail(id: UUID().uuidString, imageState: .loading, url: model.imageURL),
            headerImage: Thumbnail(id: UUID().uuidString, imageState: .loading, url: model.headerImageURL),
            mail: model.mail,
            cakes: []
        )
    }

    init(from model: ProfileEntity) {
        self = UserModel(
            id: model.id,
            fio: model.fio,
            nickname: model.nickname,
            avatarImage: Thumbnail(id: UUID().uuidString, imageState: .loading, url: model.imageURL),
            headerImage: Thumbnail(id: UUID().uuidString, imageState: .loading, url: model.headerImageURL),
            mail: model.mail,
            cakes: []
        )
    }
}
