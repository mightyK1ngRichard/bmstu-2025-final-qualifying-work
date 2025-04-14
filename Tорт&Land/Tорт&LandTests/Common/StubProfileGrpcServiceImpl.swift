//
//  StubProfileGrpcServiceImpl.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 14.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

@testable import NetworkAPI

final class StubProfileGrpcServiceImpl: ProfileGrpcService {
    func getUserInfo() async throws -> ProfileServiceModel.GetUserInfo.Response {
        fatalError("No implementation")
    }

    func closeConnection() {
        fatalError("No implementation")
    }
}
