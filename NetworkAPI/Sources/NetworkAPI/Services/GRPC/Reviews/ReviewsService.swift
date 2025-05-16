//
//  ReviewsService.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 21.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

// MARK: - ReviewsService

public protocol ReviewsService: Sendable {
    func cakeFeedbacks(cakeID: String) async throws -> [FeedbackEntity]
    func createFeedback(request: ReviewsServiceModel.CreateFeedback.Request) async throws -> ReviewsServiceModel.CreateFeedback.Response
    func closeConnection()
}

// MARK: - ReviewsGrpcServiceImpl

public final class ReviewsGrpcServiceImpl: ReviewsService {
    private let client: Feedback_ReviewServiceAsyncClient
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
            self.client = Feedback_ReviewServiceAsyncClient(channel: channel, interceptors: nil)
            self.channel = channel
            self.authService = authService
            self.networkService = networkService
        } catch {
            #if DEBUG
            fatalError("Ошибка подключения к grpc серверу профиля: \(error)")
            #else
            Logger.log(kind: .error, "Ошибка подключения к grpc серверу отзывов: \(error)")
            assertionFailure("Ошибка подключения к grpc серверу: \(error)")
            fatalError("Ошибка подключения к grpc серверу профиля: \(error)")
            #endif
        }
    }
}

public extension ReviewsGrpcServiceImpl {
    func cakeFeedbacks(cakeID: String) async throws -> [FeedbackEntity] {
        let request = Feedback_ProductFeedbacksRequest.with {
            $0.cakeID = cakeID
        }

        return try await networkService.performAndLog(
            call: client.productFeedbacks,
            with: request,
            mapping: { $0.feedbacks.map(FeedbackEntity.init(from:)) }
        )
    }

    func createFeedback(request: ReviewsServiceModel.CreateFeedback.Request) async throws -> ReviewsServiceModel.CreateFeedback.Response {
        try await networkService.maybeRefreshAccessToken(using: authService)
        let request = Feedback_AddFeedbackRequest.with {
            $0.cakeID = request.cakeID
            $0.rating = Int32(request.rating)
            $0.text = request.text
        }

        return try await networkService.performAndLog(
            call: client.addFeedback,
            with: request,
            mapping: { .init(feedback: FeedbackEntity(from: $0.feedback)) }
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
