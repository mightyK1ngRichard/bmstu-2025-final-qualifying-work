//
//  AuthGrpcService.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation
import GRPC
import NIO

// MARK: - AuthService

protocol AuthService {
    func register(req: AuthServiceModel.Register.Request) async throws -> AuthServiceModel.Register.Response
    func login(req: AuthServiceModel.Login.Request) async throws -> AuthServiceModel.Login.Response
    func updateAccessToken(req: AuthServiceModel.UpdateAccessToken.Request) async throws -> AuthServiceModel.UpdateAccessToken.Response
    func closeConnection()
}

// MARK: - AuthGrpcServiceImpl

final class AuthGrpcServiceImpl: AuthService {
    private let client: AuthAsyncClientProtocol
    private let channel: GRPCChannel
    private let networkService: NetworkService

    init(
        configuration: GRPCHostPortConfiguration,
        networkService: NetworkService
    ) {
        do {
            let channel = try ConfigProvider.makeConection(
                host: configuration.hostName,
                port: configuration.port,
                numberOfThreads: 1
            )
            let options = ConfigProvider.makeDefaultCallOptions()

            self.client = AuthAsyncClient(
                channel: channel,
                defaultCallOptions: options,
                interceptors: nil
            )
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

extension AuthGrpcServiceImpl {
    func register(req: AuthServiceModel.Register.Request) async throws -> AuthServiceModel.Register.Response {
        let request = RegisterRequest.with {
            $0.email = req.email
            $0.password = req.password
        }
        return try await networkService.performAndLog(
            call: client.register,
            with: request,
            mapping: {
                .init(accessToken: $0.accessToken, refreshToken: $0.refreshToken, expiresIn: Int($0.expiresIn))
            }
        )
    }

    func login(req: AuthServiceModel.Login.Request) async throws -> AuthServiceModel.Login.Response {
        let request = LoginRequest.with {
            $0.email = req.email
            $0.password = req.password
        }
        return try await client.login(request)
            .convertToLoginDataGRPC()
    }

    func updateAccessToken(req: AuthServiceModel.UpdateAccessToken.Request) async throws -> AuthServiceModel.UpdateAccessToken.Response {
        let request = UpdateAccessTokenRequest.with {
            $0.refreshToken = req.refreshToken
        }
        return try await client.updateAccessToken(request)
            .convertToLoginDataGRPC()
    }

    func closeConnection() {
        do {
            try channel.close().wait()
        } catch {
            Logger.log(kind: .error, error)
        }
    }
}
