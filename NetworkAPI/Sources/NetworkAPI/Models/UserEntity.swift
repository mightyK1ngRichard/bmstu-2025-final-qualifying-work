//
//  UserEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//

import Foundation

/// Информация о владельце
public struct UserEntity: Sendable {
    /// ID пользователя
    public let id: String
    /// Полное имя
    public let fio: String?
    /// Никнейм
    public let nickname: String
    /// Электронная почта
    public let mail: String
}

// MARK: - User

extension UserEntity {
    init(from model: User) {
        let fio = model.hasFio ? model.fio.value : nil
        self = UserEntity(
            id: model.id,
            fio: fio,
            nickname: model.nickname,
            mail: model.mail
        )
    }
}
