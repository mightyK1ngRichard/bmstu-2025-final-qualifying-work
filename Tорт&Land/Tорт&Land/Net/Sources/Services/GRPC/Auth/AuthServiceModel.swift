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

    struct Response: GrpcConvertable {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
    }
}

extension AuthServiceModel.Register.Response {
    init(from model: RegisterResponse) {
        self = .init(
            accessToken: model.accessToken,
            refreshToken: model.refreshToken,
            expiresIn: Int(model.expiresIn)
        )
    }
}

// MARK: - Login

extension AuthServiceModel.Login {
    struct Request {
        let email: String
        let password: String
    }

    struct Response: GrpcConvertable {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
    }
}

extension AuthServiceModel.Login.Response {
    init(from model: LoginResponse) {
        self = .init(
            accessToken: model.accessToken,
            refreshToken: model.refreshToken,
            expiresIn: Int(model.expiresIn)
        )
    }
}

// MARK: - UpdateAccessToken

extension AuthServiceModel.UpdateAccessToken {
    struct Request {
        let refreshToken: String
    }

    struct Response: GrpcConvertable {
        let accessToken: String
        let expiresIn: Int
    }
}

extension AuthServiceModel.UpdateAccessToken.Response {
    init(from model: UpdateAccessTokenResponse) {
        self = .init(
            accessToken: model.accessToken,
            expiresIn: Int(model.expiresIn)
        )
    }
}
