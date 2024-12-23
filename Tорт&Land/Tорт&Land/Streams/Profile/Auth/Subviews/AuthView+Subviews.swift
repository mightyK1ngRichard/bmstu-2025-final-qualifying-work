//
//  AuthView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//

import SwiftUI

extension AuthView {

    var mainView: some View {
        Group {
            if !viewModel.uiProperties.isRegister {
                signInView
                    .transition(.flip)
            } else {
                registerView
                    .transition(.reverseFlip)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Constants.bgColor)
        .clipShape(
            .rect(
                cornerRadius: (
                    UIScreen.current?.displayCornerRadius ?? 0 > 26
                ) ? 26 : 0
            )
        )
        .alert(Constants.errorTitle, isPresented: $viewModel.uiProperties.showingAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.uiProperties.alertMessage)
        }
    }

    var signInView: some View {
        VStack {
            logoView
            VStack {
                titleView(title: Constants.signInTitle)
                inputEmailBlock
                inputPasswordBlock
                authRegisterToggleButton(title: Constants.dontHaveAccountTitle)
                nextButtonView
            }
            .padding()
        }
    }

    var logoView: some View {
        Image(.cakeLogo)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundStyle(Constants.logoColor)
    }

    func titleView(title: String) -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Constants.titleColor)
            .kerning(1.9)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var inputEmailBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Constants.emailTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            TextField(Constants.emailTitle, text: $viewModel.uiProperties.email)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        }
        .padding(.top, 25)
    }

    var inputPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Constants.passwordTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            SecureField(Constants.passwordTitle, text: $viewModel.uiProperties.password)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Constants.textColor)
                .padding(.top, 5)

            Divider()
        }
        .padding(.top, 20)
    }

    func authRegisterToggleButton(title: String) -> some View {
        Button(action: viewModel.didTapToggleAuthMode, label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
        })
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 10)
    }

    var nextButtonView: some View {
        Button(action: viewModel.didTapNextButton, label: {
            Image(systemName: "arrow.right")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Constants.iconColor)
                .padding()
                .background(Constants.bgColor)
                .clipShape(Circle())
                .shadow(color: Color.gray.opacity(0.6), radius: 5, x: 0, y: 0)

        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }
}

// MARK: - Preview

#Preview {
    AuthView(viewModel: AuthViewModelMock())
}

// MARK: - Constants

extension AuthView {
    enum Constants {
        static let titleColor = TLColor<TextPalette>.textRed.color
        static let textColor = TLColor<TextPalette>.textPrimary.color
        static let logoColor = TLColor<IconPalette>.iconPrimary.color.gradient
        static let iconColor = TLColor<IconPalette>.iconRed.color.gradient
        static let bgColor = TLColor<BackgroundPalette>.bgMainColor.color

        static let nicknameTitle = String(localized: "Nickname")
        static let passwordTitle = String(localized: "Password")
        static let repeatPasswordTitle = String(localized: "Repeat Password")
        static let emailTitle = String(localized: "Email")
        static let signInTitle = String(localized: "Sign In")
        static let registerTitle = String(localized: "Register")
        static let dontHaveAccountTitle = String(localized: "Don't have account?")
        static let haveAccountTitle = String(localized: "Already have account?")
        static let errorTitle = String(localized: "Error")
    }
}
