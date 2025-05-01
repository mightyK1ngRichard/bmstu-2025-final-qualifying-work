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
    static func assemble(profileProvider: ProfileGrpcService) -> SettingsView {
        let viewModel = SettingsViewModel(profileProvider: profileProvider)
        return SettingsView(viewModel: viewModel)
    }
}
