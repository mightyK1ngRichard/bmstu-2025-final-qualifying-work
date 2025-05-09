//
//  SettingsAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class SettingsAssembler {
    static func assemble(userModel: UserModel, authService: AuthService, profileProvider: ProfileService) -> SettingsView {
        let viewModel = SettingsViewModel(
            userModel: userModel,
            authProvider: authService,
            profileProvider: profileProvider
        )
        return SettingsView(viewModel: viewModel)
    }
}
