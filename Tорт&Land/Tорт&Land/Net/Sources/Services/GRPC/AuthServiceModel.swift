//
//  AuthServiceModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation

enum AuthServiceModel {
    enum Register {}
    enum Login {}
    enum UpdateAccessToken {}
}

// MARK: - Register

extension AuthServiceModel.Register {
    struct Request {
        let email: String
        let password: String
    }

    struct Response {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
    }
}

extension RegisterResponse {
    func convertToRegisterDataGRPC() -> AuthServiceModel.Register.Response {
        .init(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: Int(expiresIn)
        )
    }
}

// MARK: - Login

extension AuthServiceModel.Login {
    struct Request {
        let email: String
        let password: String
    }

    struct Response {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
    }
}

extension LoginResponse {
    func convertToLoginDataGRPC() -> AuthServiceModel.Login.Response {
        .init(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: Int(expiresIn)
        )
    }
}

// MARK: - UpdateAccessToken

extension AuthServiceModel.UpdateAccessToken {
    struct Request {
        let refreshToken: String
    }

    struct Response {
        let accessToken: String
        let expiresIn: Int
    }
}

extension UpdateAccessTokenResponse {
    func convertToLoginDataGRPC() -> AuthServiceModel.UpdateAccessToken.Response {
        .init(
            accessToken: accessToken,
            expiresIn: Int(expiresIn)
        )
    }
}
