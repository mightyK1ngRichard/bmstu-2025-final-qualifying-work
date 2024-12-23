//
//  AuthModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//

import Foundation

enum AuthModel {}

extension AuthModel {
    struct UIProperties {
        var isRegister = false
        var showingAlert = false
        var nickName = ""
        var email = ""
        var password = ""
        var repeatPassword = ""
        var alertMessage = ""
    }
}
