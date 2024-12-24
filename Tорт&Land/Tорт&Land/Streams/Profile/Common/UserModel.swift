//
//  UserModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

struct UserModel: Identifiable, Hashable {
    /// Код пользователя
    let id: String
    /// Имя пользователя
    let name: String
}
