//
//  UserModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

struct UserModel: Identifiable, Hashable {
    /// Код пользователя
    let id: String
    /// Имя пользователя
    let name: String
    /// Почта пользователя
    let mail: String
    /// Аватарка пользователя
    var avatarImage: ImageState
    /// Шапка пользователя
    var headerImage: ImageState
    /// Продавайемые торты пользователя
    var cakes: [CakeModel]
}

extension UserModel {
    init(from model: UserInfoEntity) {
        let user = model.profile

        self = UserModel(
            id: user.id,
            name: user.fio ?? StringConstants.anonimeUserName,
            mail: user.mail,
            avatarImage: .loading,
            headerImage: .loading,
            cakes: model.previewCakes.map(CakeModel.init(from:))
        )
    }

    init(from model: UserEntity) {
        self = UserModel(
            id: model.id,
            name: model.fio ?? StringConstants.anonimeUserName,
            mail: model.mail,
            avatarImage: .loading,
            headerImage: .loading,
            cakes: []
        )
    }
}
