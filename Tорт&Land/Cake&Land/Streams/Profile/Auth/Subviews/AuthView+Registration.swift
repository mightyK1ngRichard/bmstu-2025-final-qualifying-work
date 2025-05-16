//
//  AuthView+Registration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension AuthView {
    
    var registerView: some View {
        VStack {
            if !UIDevice.isSe {
                logoView
            }

            VStack {
                titleView(title: Constants.registerTitle)
                inputNicknameBlock
                inputEmailBlock
                inputPasswordBlock
                inputRepeatPasswordBlock
                authRegisterToggleButton(title: Constants.haveAccountTitle)
                nextButtonView
            }
            .padding()
        }
    }

    var inputNicknameBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Constants.nicknameTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            TextField(Constants.nicknameTitle, text: $viewModel.uiProperties.nickName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)
                .disabled(viewModel.uiProperties.isLoading)

            Divider()
        }
        .padding(.top, 25)
    }

    var inputRepeatPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Constants.repeatPasswordTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            SecureField(Constants.passwordTitle, text: $viewModel.uiProperties.repeatPassword)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)
                .disabled(viewModel.uiProperties.isLoading)

            Divider()
        }
        .padding(.top, 20)
    }
}
