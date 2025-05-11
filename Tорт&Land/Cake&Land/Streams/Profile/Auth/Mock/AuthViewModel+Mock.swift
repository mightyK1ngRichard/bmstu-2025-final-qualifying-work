//
//  AuthViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation
import SwiftUI

@Observable
final class AuthViewModelMock: AuthDisplayLogic, AuthViewModelOutput {
    var uiProperties = AuthModel.UIProperties()
    @ObservationIgnored
    private var startScreenControl: StartScreenControl?

    init(uiProperties: AuthModel.UIProperties = AuthModel.UIProperties()) {
        self.uiProperties = uiProperties
    }
}

extension AuthViewModelMock {

    func didTapNextButton() {
//        if uiProperties.isRegister {
//            didTapRegisterButton()
//        } else {
//            didTapSignInButton()
//        }
//        startScreenControl?.update(with: .cakesList)
    }

    func didTapToggleAuthMode() {
        withAnimation(.bouncy(duration: 2)) {
            uiProperties.isRegister.toggle()
        }
    }

    func setStartScreenControl(_ startScreenControl: StartScreenControl) {
        self.startScreenControl = startScreenControl
    }
}

private extension AuthViewModelMock {

    func didTapRegisterButton() {
        print("[DEBUG]: Нажали кнопку регистрация")
    }

    func didTapSignInButton() {
        print("[DEBUG]: Нажали кнопку войти")
    }
}

#endif
