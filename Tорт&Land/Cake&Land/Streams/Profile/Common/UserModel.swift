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
    var avatarImage: ImageState
    /// Шапка пользователя
    var headerImage: ImageState
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
            avatarImage: .loading,
            headerImage: .loading,
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
            avatarImage: .loading,
            headerImage: .loading,
            mail: model.mail,
            cakes: []
        )
    }

    init(from model: ProfileEntity) {
        self = UserModel(
            id: model.id,
            fio: model.fio,
            nickname: model.nickname,
            avatarImage: .loading,
            headerImage: .loading,
            mail: model.mail,
            cakes: []
        )
    }
}
