//
//  RootModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum RootModel {}

extension RootModel {
    struct UIProperties: Hashable {
    }

    enum Screens: Hashable {
        case details(CakeModel)
        case profile(UserModel)
        case makeOrder(cakeID: String)
    }
}
