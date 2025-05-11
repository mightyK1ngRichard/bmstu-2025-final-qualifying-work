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
import Core

// MARK: - AuthService

public protocol AuthService: Sendable {
    func register(req: AuthServiceModel.Register.Request) async throws -> AuthServiceModel.Register.Response
    func login(req: AuthServiceModel.Login.Request) async throws -> AuthServiceModel.Login.Response
    func updateAccessToken() async throws -> AuthServiceModel.UpdateAccessToken.Response
    func logout() async throws
    func closeConnection()
}

// MARK: - AuthGrpcServiceImpl

public final class AuthGrpcServiceImpl: AuthService, Sendable {
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
            $0.nickname = req.nickname
        }
        let result = try await networkService.performAndLog(
            call: client.register,
            with: request,
            mapping: { AuthServiceModel.Register.Response(from: $0) }
        )

        await networkService.setTokens(
            accessToken: result.accessToken,
            expiresIn: Date(timeIntervalSince1970: TimeInterval(result.expiresIn)),
            refreshToken: result.refreshToken
        )

        return result
    }

    func login(req: AuthServiceModel.Login.Request) async throws -> AuthServiceModel.Login.Response {
        let request = LoginRequest.with {
            $0.email = req.email
            $0.password = req.password
        }

        let result = try await networkService.performAndLog(
            call: client.login,
            with: request,
            mapping: { AuthServiceModel.Login.Response(from: $0) }
        )

        await networkService.setTokens(
            accessToken: result.accessToken,
            expiresIn: Date(timeIntervalSince1970: TimeInterval(result.expiresIn)),
            refreshToken: result.refreshToken
        )
        
        return result
    }

    func updateAccessToken() async throws -> AuthServiceModel.UpdateAccessToken.Response {
        guard let refreshToken = networkService.refreshToken, !refreshToken.isEmpty else {
            throw NetworkError.missingRefreshToken
        }

        var callOptions = CallOptions()
        callOptions.customMetadata.add(name: "authorization", value: "Bearer \(refreshToken)")

        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.updateAccessToken,
            with: request,
            options: callOptions,
            mapping: { .init(from: $0) }
        )
    }

    func logout() async throws {
        guard let refreshToken = networkService.refreshToken, !refreshToken.isEmpty else {
            throw NetworkError.missingRefreshToken
        }

        let request = Google_Protobuf_Empty()
        var callOptions = networkService.callOptions
        callOptions.customMetadata.add(name: "authorization", value: "Bearer \(refreshToken)")

        try await networkService.performAndLog(
            call: client.logout,
            with: request,
            options: callOptions,
            mapping: { _ in }
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
