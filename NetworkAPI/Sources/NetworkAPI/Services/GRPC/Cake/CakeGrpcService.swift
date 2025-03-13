//
//  CakeGrpcService.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 13.03.2025.
//

import Foundation
import GRPC
import NIO

// MARK: - AuthService

public protocol CakeGrpcService: Sendable {
    func createCategory(req: CakeServiceModel.CreateCategory.Request) async throws -> CakeServiceModel.CreateCategory.Response
    func closeConnection()
}

// MARK: - AuthGrpcServiceImpl

public final class CakeGrpcServiceImpl: CakeGrpcService, Sendable {
    private let client: CakeServiceAsyncClientProtocol
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
            self.client = CakeServiceAsyncClient(channel: channel, interceptors: nil)
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

public extension CakeGrpcServiceImpl {
    func createCategory(req: CakeServiceModel.CreateCategory.Request) async throws -> CakeServiceModel.CreateCategory.Response {
        let request = CreateCategoryRequest.with {
            $0.name = req.name
            $0.imageData = req.imageData
        }

        return try await networkService.performAndLog(
            call: client.createCategory,
            with: request,
            mapping: { .init(id: $0.category.id, name: $0.category.name, imageURL: $0.category.imageURL) }
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
