//
//  UserModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

import Foundation

struct UserModel: Identifiable, Hashable {
    /// Код пользователя
    let id: String
    /// Имя пользователя
    let name: String
}
