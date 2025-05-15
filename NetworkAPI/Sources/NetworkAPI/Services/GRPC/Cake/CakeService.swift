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

// MARK: - CakeService

public protocol CakeService: Sendable {
    // Торты
    func createCake(req: CakeServiceModel.CreateCake.Request) async throws -> CakeServiceModel.CreateCake.Response
    func fetchCakes() async throws -> CakeServiceModel.FetchCakes.Response
    func fetchAllCakesWithAllStatuses() async throws -> [PreviewCakeEntity]
    func fetchCakeByID(cakeID: String) async throws -> CakeEntity
    func addCakeColors(req: CakeServiceModel.AddCakeColors.Request) async throws
    func fetchColors() async throws -> [String]
    func add3DModel(cakeID: String, modelData: Data) async throws -> String
    func updateCakeVisibility(cakeID: String, status: CakeStatusEntity) async throws
    // Начинки
    func createFilling(req: CakeServiceModel.CreateFilling.Request) async throws -> CakeServiceModel.CreateFilling.Response
    func fetchFillings() async throws -> CakeServiceModel.FetchFillings.Response
    // Категории
    func createCategory(req: CakeServiceModel.CreateCategory.Request) async throws -> CakeServiceModel.CreateCategory.Response
    func fetchCategoriesByGenderName(gender: CategoryGender) async throws -> CakeServiceModel.FetchCategoriesByGenderName.Response
    func fetchCategories() async throws -> CakeServiceModel.FetchCategories.Response
    func fetchCategoryCakes(categoryID: String) async throws -> CakeServiceModel.FetchCategoryCakes.Response

    func closeConnection()
}

// MARK: - CakeGrpcServiceImpl

public final class CakeGrpcServiceImpl: CakeService {
    private let client: Cake_CakeServiceAsyncClientProtocol
    private let channel: GRPCChannel
    private let authService: AuthService
    private let networkService: NetworkService

    public init(
        configuration: GRPCHostPortConfiguration,
        authService: AuthService,
        networkService: NetworkService
    ) {
        do {
            let channel = try ConfigProvider.makeConection(
                host: configuration.hostName,
                port: configuration.port,
                numberOfThreads: 1
            )
            self.client = Cake_CakeServiceAsyncClient(channel: channel, interceptors: nil)
            self.channel = channel
            self.authService = authService
            self.networkService = networkService
        } catch {
            #if DEBUG
            fatalError("Ошибка подключения к grpc серверу: \(error)")
            #else
            Logger.log(kind: .error, "Ошибка подключения к grpc серверу: \(error)")
            assertionFailure("Ошибка подключения к grpc серверу: \(error)")
            fatalError("Ошибка подключения к grpc серверу профиля: \(error)")
            #endif
        }
    }
}

public extension CakeGrpcServiceImpl {

    func fetchAllCakesWithAllStatuses() async throws -> [PreviewCakeEntity] {
        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.getAllCakesWithAllStatuses,
            with: request,
            mapping: { $0.cakes.map(PreviewCakeEntity.init(from:)) }
        )
    }

    func updateCakeVisibility(cakeID: String, status: CakeStatusEntity) async throws {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Cake_SetCakeVisibilityReq.with {
            $0.cakeID = cakeID
            $0.status = status.toProto()
        }

        return try await networkService.performAndLog(
            call: client.setCakeVisibility,
            with: request,
            mapping: { _ in }
        )
    }

    func fetchColors() async throws -> [String] {
        return try await networkService.performAndLog(
            call: client.getColors,
            with: Google_Protobuf_Empty(),
            mapping: \.colorsHex
        )
    }

    func addCakeColors(req: CakeServiceModel.AddCakeColors.Request) async throws {
        let request = Cake_AddCakeColorsReq.with {
            $0.cakeID = req.cakeID
            $0.colorsHex = req.hexStrings
        }

        return try await networkService.performAndLog(
            call: client.addCakeColors,
            with: request,
            mapping: { _ in }
        )
    }

    /// - Important: Может только админ
    func createCategory(req: CakeServiceModel.CreateCategory.Request) async throws -> CakeServiceModel.CreateCategory.Response {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Cake_CreateCategoryRequest.with {
            $0.name = req.name
            $0.imageData = req.imageData
            $0.genderTags = req.genderTags.map { $0.convertToGrpcModel() }
        }

        return try await networkService.performAndLog(
            call: client.createCategory,
            with: request,
            mapping: {
                .init(category: CategoryEntity(from: $0.category))
            }
        )
    }

    func createFilling(req: CakeServiceModel.CreateFilling.Request) async throws -> CakeServiceModel.CreateFilling.Response {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Cake_CreateFillingRequest.with {
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
                .init(filling: FillingEntity(from: $0.filling))
            }
        )
    }

    func fetchFillings() async throws -> CakeServiceModel.FetchFillings.Response {
        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.fillings,
            with: request,
            mapping: {
                .init(
                    fillings: $0.fillings.map { FillingEntity(from: $0) }
                )
            }
        )
    }

    func fetchCategories() async throws -> CakeServiceModel.FetchCategories.Response {
        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.categories,
            with: request,
            mapping: {
                .init(categories: $0.categories.map { CategoryEntity(from: $0) })
            }
        )
    }

    func createCake(req: CakeServiceModel.CreateCake.Request) async throws -> CakeServiceModel.CreateCake.Response {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Cake_CreateCakeRequest.with {
            $0.name = req.name
            $0.previewImageData = req.previewImageData
            $0.kgPrice = req.kgPrice
            $0.description_p = req.description
            $0.mass = req.mass
            $0.fillingIds = req.fillingIDs
            $0.categoryIds = req.categoryIDs
            $0.images = req.imagesData
            // nullable discount price
            if let discountEnd = req.discountEndTime {
                $0.discountEndTime = Google_Protobuf_Timestamp(date: discountEnd)
            }
            // nullable discount price
            if let discountPrice = req.discountKgPrice {
                $0.discountKgPrice = Google_Protobuf_DoubleValue(discountPrice)
            }
        }

        return try await networkService.performAndLog(
            call: client.createCake,
            with: request,
            mapping: { .init(cakeID: $0.cakeID) }
        )
    }

    func fetchCakes() async throws -> CakeServiceModel.FetchCakes.Response {
        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.cakes,
            with: request,
            mapping: {
                .init(cakes: $0.cakes.map { PreviewCakeEntity(from: $0) })
            }
        )
    }


    func fetchCakeByID(cakeID: String) async throws -> CakeEntity {
        let request = Cake_CakeRequest.with {
            $0.cakeID = cakeID
        }

        return try await networkService.performAndLog(
            call: client.cake,
            with: request,
            mapping: { CakeEntity(from: $0.cake) }
        )
    }

    func fetchCategoriesByGenderName(gender: CategoryGender) async throws -> CakeServiceModel.FetchCategoriesByGenderName.Response {
        let request = Cake_GetCategoriesByGenderNameReq.with {
            $0.categoryGender = gender.convertToGrpcModel()
        }

        return try await networkService.performAndLog(
            call: client.getCategoriesByGenderName,
            with: request,
            mapping: { .init(categories: $0.categories.map(CategoryEntity.init(from:))) }
        )
    }

    func fetchCategoryCakes(categoryID: String) async throws -> CakeServiceModel.FetchCategoryCakes.Response {
        let request = Cake_CategoryPreviewCakesReq.with {
            $0.categoryID = categoryID
        }

        return try await networkService.performAndLog(
            call: client.categoryPreviewCakes,
            with: request,
            mapping: { .init(cakes: $0.previewCakes.map(ProfilePreviewCakeEntity.init(from:))) }
        )
    }

    func add3DModel(cakeID: String, modelData: Data) async throws -> String {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Cake_Add3DModelReq.with {
            $0.cakeID = cakeID
            $0.modelFileData = modelData
        }

        return try await networkService.performAndLog(
            call: client.add3DModel,
            with: request,
            mapping: { $0.model3Durl }
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
