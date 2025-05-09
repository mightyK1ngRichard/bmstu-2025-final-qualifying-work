//
//  ProfileModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum ProfileModel {}

extension ProfileModel {
    struct UIProperties: Hashable {
        var screenState: ScreenState = .initial
        var alert = AlertModel()
    }

    enum Screens: Hashable {
        case createProfile
        case orders
        case sendMessage(currentUser: UserModel, interlocutor: UserModel)
        case settings(userModel: UserModel)
    }
}
