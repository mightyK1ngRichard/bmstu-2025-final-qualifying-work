//
//  UserModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation
import NetworkAPI
import AppKit

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

    var titleName: String {
        fio ?? nickname
    }
}

extension UserModel {
    init(from model: UserEntity) {
        let avatar: Thumbnail = {
            if let imageURL = model.imageURL {
                return Thumbnail(url: imageURL)
            }
            return Thumbnail(url: "", imageState: .nsImage(.profile))
        }()
        let headerImage: Thumbnail = {
            if let imageURL = model.headerImageURL {
                return Thumbnail(url: imageURL)
            }
            return Thumbnail(url: "", imageState: .nsImage(.defaultHeader))
        }()

        self = UserModel(
            id: model.id,
            fio: model.fio,
            nickname: model.nickname,
            avatarImage: avatar,
            headerImage: headerImage,
            mail: model.mail
        )
    }

    init(from model: ProfileEntity) {
        let avatar: Thumbnail = {
            if let imageURL = model.imageURL {
                return Thumbnail(url: imageURL)
            }
            return Thumbnail(url: "", imageState: .nsImage(.profile))
        }()
        let headerImage: Thumbnail = {
            if let imageURL = model.headerImageURL {
                return Thumbnail(url: imageURL)
            }
            return Thumbnail(url: "", imageState: .nsImage(.defaultHeader))
        }()

        self = UserModel(
            id: model.id,
            fio: model.fio,
            nickname: model.nickname,
            avatarImage: avatar,
            headerImage: headerImage,
            mail: model.mail
        )
    }
}
