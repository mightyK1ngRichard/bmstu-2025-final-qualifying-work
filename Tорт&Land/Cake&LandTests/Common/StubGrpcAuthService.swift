//
//  StubGrpcAuthService.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 14.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

@testable import NetworkAPI

final class StubGrpcAuthService: AuthService {
    func register(req: NetworkAPI.AuthServiceModel.Register.Request) async throws -> NetworkAPI.AuthServiceModel.Register.Response {
        fatalError("No implementation")
    }

    func login(req: NetworkAPI.AuthServiceModel.Login.Request) async throws -> NetworkAPI.AuthServiceModel.Login.Response {
        fatalError("No implementation")
    }

    func updateAccessToken() async throws -> NetworkAPI.AuthServiceModel.UpdateAccessToken.Response {
        fatalError("No implementation")
    }

    func closeConnection() {
        fatalError("No implementation")
    }
}
