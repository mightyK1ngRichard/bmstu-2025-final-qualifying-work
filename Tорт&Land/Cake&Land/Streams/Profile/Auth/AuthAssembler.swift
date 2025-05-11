//
//  AuthAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 10.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import NetworkAPI
import Foundation

final class AuthAssembler {
    static func assemble(authService: AuthService) -> AuthView {
        let viewModel = AuthViewModel(authService: authService)
        return AuthView(viewModel: viewModel)
    }
}
