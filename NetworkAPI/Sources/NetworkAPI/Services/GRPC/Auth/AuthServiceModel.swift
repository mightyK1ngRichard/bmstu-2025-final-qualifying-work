//
//  AuthServiceModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

public enum AuthServiceModel {
    public enum Register {}
    public enum Login {}
    public enum UpdateAccessToken {}
}

// MARK: - Register

public extension AuthServiceModel.Register {
    struct Request {
        let email: String
        let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }

    struct Response: Sendable {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
    }
}

extension AuthServiceModel.Register.Response: GrpcConvertable {
    init(from model: RegisterResponse) {
        self = .init(
            accessToken: model.accessToken,
            refreshToken: model.refreshToken,
            expiresIn: Int(model.expiresIn)
        )
    }
}

// MARK: - Login

public extension AuthServiceModel.Login {
    struct Request {
        let email: String
        let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }

    struct Response: Sendable {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
    }
}

extension AuthServiceModel.Login.Response: GrpcConvertable {
    init(from model: LoginResponse) {
        self = .init(
            accessToken: model.accessToken,
            refreshToken: model.refreshToken,
            expiresIn: Int(model.expiresIn)
        )
    }
}

// MARK: - UpdateAccessToken

public extension AuthServiceModel.UpdateAccessToken {
    struct Response: Sendable {
        let accessToken: String
        let expiresIn: Int
    }
}

extension AuthServiceModel.UpdateAccessToken.Response: GrpcConvertable {
    init(from model: UpdateAccessTokenResponse) {
        self = .init(
            accessToken: model.accessToken,
            expiresIn: Int(model.expiresIn)
        )
    }
}
