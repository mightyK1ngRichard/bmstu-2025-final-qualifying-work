//
//  AuthViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Observation
import SwiftUI

@Observable
final class AuthViewModel: AuthDisplayLogic, AuthViewModelOutput {
    var uiProperties = AuthModel.UIProperties()
    @ObservationIgnored
    private let authService: AuthService
    @ObservationIgnored
    private var startScreenControl: StartScreenControl?

    init(authService: AuthService) {
        self.authService = authService
    }
}

// MARK: - Network

extension AuthViewModel {

    func registerUser() async throws {
        let _ = try await authService.register(
            req: .init(
                email: uiProperties.email.lowercased(),
                password: uiProperties.password,
                nickname: uiProperties.nickName
            )
        )
    }

    func loginUser() async throws {
        let _ = try await authService.login(req: .init(email: uiProperties.email.lowercased(), password: uiProperties.password))
    }

}

// MARK: - Actions

extension AuthViewModel {

    func didTapNextButton() {
        if uiProperties.isRegister {
            didTapRegisterButton()
        } else {
            didTapSignInButton()
        }
    }

    func didTapToggleAuthMode() {
        withAnimation(.bouncy(duration: 2)) {
            uiProperties.isRegister.toggle()
        }
    }

    func setStartScreenControl(_ startScreenControl: StartScreenControl) {
        self.startScreenControl = startScreenControl
    }

    func didTapRegisterButton() {
        guard !uiProperties.email.isEmpty, !uiProperties.password.isEmpty, !uiProperties.repeatPassword.isEmpty else {
            uiProperties.alertMessage = "Заполните все поля!"
            uiProperties.showingAlert = true
            return
        }
        if uiProperties.password != uiProperties.repeatPassword {
            uiProperties.alertMessage = "Пароли не совпадают!"
            uiProperties.showingAlert = true
            return
        }

        uiProperties.isLoading = true
        Task { @MainActor in
            do {
                try await registerUser()
                startScreenControl?.update(with: .cakesList)
            } catch {
                uiProperties.alertMessage = error.localizedDescription
                uiProperties.showingAlert = true
            }
            uiProperties.isLoading = false
        }
    }

    func didTapSignInButton() {
        guard !uiProperties.email.isEmpty, !uiProperties.password.isEmpty else {
            uiProperties.alertMessage = "Заполните все поля!"
            uiProperties.showingAlert = true
            return
        }

        uiProperties.isLoading = true
        Task { @MainActor in
            do {
                try await loginUser()
                startScreenControl?.update(with: .cakesList)
            } catch {
                uiProperties.alertMessage = error.localizedDescription
                uiProperties.showingAlert = true
            }
            uiProperties.isLoading = false
        }
    }
}
