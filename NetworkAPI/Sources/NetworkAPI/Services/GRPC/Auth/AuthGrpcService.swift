//
//  AuthGrpcService.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftProtobuf
import GRPC
import NIO

// MARK: - AuthService

public protocol AuthService {
    func register(req: AuthServiceModel.Register.Request) async throws -> AuthServiceModel.Register.Response
    func login(req: AuthServiceModel.Login.Request) async throws -> AuthServiceModel.Login.Response
    func updateAccessToken(req: AuthServiceModel.UpdateAccessToken.Request) async throws -> AuthServiceModel.UpdateAccessToken.Response
    func closeConnection()
}

// MARK: - AuthGrpcServiceImpl

public final class AuthGrpcServiceImpl: AuthService {
    private let client: AuthAsyncClientProtocol
    private let channel: GRPCChannel
    private let networkService: NetworkService

    public init(
        configuration: GRPCHostPortConfiguration,
        networkService: NetworkService
    ) {
        do {
            let channel = try ConfigProvider.makeConection(
                host: configuration.hostName,
                port: configuration.port,
                numberOfThreads: 1
            )
            self.client = AuthAsyncClient(channel: channel, interceptors: nil)
            self.channel = channel
            self.networkService = networkService
        } catch {
            #if DEBUG
            fatalError("Ошибка подключения к grpc серверу: \(error)")
            #else
            Logger.log(kind: .error, "Ошибка подключения к grpc серверу: \(error)")
            assertionFailure("Ошибка подключения к grpc серверу: \(error)")
            #endif
        }
    }
}

public extension AuthGrpcServiceImpl {
    func register(req: AuthServiceModel.Register.Request) async throws -> AuthServiceModel.Register.Response {
        let request = RegisterRequest.with {
            $0.email = req.email
            $0.password = req.password
        }
        return try await networkService.performAndLog(
            call: client.register,
            with: request,
            mapping: { .init(from: $0) }
        )
    }

    func login(req: AuthServiceModel.Login.Request) async throws -> AuthServiceModel.Login.Response {
        let request = LoginRequest.with {
            $0.email = req.email
            $0.password = req.password
        }
        return try await networkService.performAndLog(
            call: client.login,
            with: request,
            mapping: { .init(from: $0) }
        )
    }

    func updateAccessToken(req: AuthServiceModel.UpdateAccessToken.Request) async throws -> AuthServiceModel.UpdateAccessToken.Response {
        let request = Google_Protobuf_Empty()
        var callOptions = CallOptions()
        guard let refresthToken = networkService.refreshToken else {
            throw NetworkError.missingRefreshToken
        }

        callOptions.customMetadata.add(name: "authorization", value: "Bearer \(refresthToken)")

        return try await networkService.performAndLog(
            call: client.updateAccessToken,
            with: request,
            options: callOptions,
            mapping: { .init(from: $0) }
        )
    }

    func closeConnection() {
        do {
            try channel.close().wait()
        } catch {
            Logger.log(kind: .error, error)
        }
    }
}
