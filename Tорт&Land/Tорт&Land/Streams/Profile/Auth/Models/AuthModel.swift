//
//  AuthModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum AuthModel {}

extension AuthModel {
    struct UIProperties {
        var isLoading = false
        var isRegister = false
        var showingAlert = false
        var nickName = ""
        var email = ""
        var password = ""
        var repeatPassword = ""
        var alertMessage = ""
    }
}
