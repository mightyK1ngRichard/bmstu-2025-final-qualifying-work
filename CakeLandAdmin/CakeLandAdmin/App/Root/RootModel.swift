//
//  RootModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

enum RootModel {
    struct BinindingData: Hashable {
        var startScreenKind: StartScreenKind = .needAuth
        var selectedTab: AppSection = .home
        var state: ScreenState = .initial
        var alert = AlertModel()
        var inputEmail = ""
        var inputPassword = ""
        var isSecure = true
        var signInButtonIsLoading = false

        var signInButtonIsDisabled: Bool {
            inputEmail.isEmpty || inputPassword.isEmpty
        }
    }
}
