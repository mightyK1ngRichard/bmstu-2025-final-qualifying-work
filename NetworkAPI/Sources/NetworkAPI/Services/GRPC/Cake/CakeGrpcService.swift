//
//  CakeGrpcService.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 13.03.2025.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

// MARK: - AuthService

public protocol CakeGrpcService: Sendable {
    func createCake(req: CakeServiceModel.CreateCake.Request) async throws -> CakeServiceModel.CreateCake.Response
    func createCategory(req: CakeServiceModel.CreateCategory.Request) async throws -> CakeServiceModel.CreateCategory.Response
    func createFilling(req: CakeServiceModel.CreateFilling.Request) async throws -> CakeServiceModel.CreateFilling.Response
    func fetchFillings() async throws -> [CakeServiceModel.CreateFilling.Response]
    func fetchCategories() async throws -> [CakeServiceModel.FetchCategories.Response]
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

    func createFilling(req: CakeServiceModel.CreateFilling.Request) async throws -> CakeServiceModel.CreateFilling.Response {
        let request = CreateFillingRequest.with {
            $0.name = req.name
            $0.imageData = req.imageData
            $0.content = req.content
            $0.kgPrice = req.kgPrice
            $0.description_p = req.description
        }

        return try await networkService.performAndLog(
            call: client.createFilling,
            with: request,
            mapping: {
                .init(
                    id: $0.filling.id,
                    name: $0.filling.name,
                    imageURL: $0.filling.imageURL,
                    content: $0.filling.content,
                    kgPrice: $0.filling.kgPrice,
                    description: $0.filling.description_p
                )
            }
        )
    }

    func fetchFillings() async throws -> [CakeServiceModel.CreateFilling.Response] {
        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.fillings,
            with: request,
            mapping: {
                $0.fillings.map {
                    .init(
                        id: $0.id,
                        name: $0.name,
                        imageURL: $0.imageURL,
                        content: $0.content,
                        kgPrice: $0.kgPrice,
                        description: $0.description_p
                    )
                }
            }
        )
    }

    func fetchCategories() async throws -> [CakeServiceModel.FetchCategories.Response] {
        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.categories,
            with: request,
            mapping: {
                $0.categories.map {
                    .init(
                        id: $0.id,
                        name: $0.name,
                        imageURL: $0.imageURL
                    )
                }
            }
        )
    }

    func createCake(req: CakeServiceModel.CreateCake.Request) async throws -> CakeServiceModel.CreateCake.Response {
        let request = CreateCakeRequest.with {
            $0.name = $0.name
            $0.imageData = req.imageData
            $0.kgPrice = req.kgPrice
            $0.rating = Int32(req.rating)
            $0.description_p = req.description
            $0.mass = req.mass
            $0.isOpenForSale = req.isOpenForSale
            $0.fillingIds = req.fillingIDs
            $0.categoryIds = req.categoryIDs
        }
        var callOptions = CallOptions()
        guard let accessToken = networkService.accessToken else {
            throw NetworkError.missingAccessToken
        }

        callOptions.customMetadata.add(name: "authorization", value: "Bearer \(accessToken)")

        return try await networkService.performAndLog(
            call: client.createCake,
            with: request,
            options: callOptions,
            mapping: { .init(cakeID: $0.cakeID) }
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
