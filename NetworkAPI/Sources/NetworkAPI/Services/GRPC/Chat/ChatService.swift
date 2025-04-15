//
//  ChatService.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 15.04.2025.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

public protocol ChatService: Sendable {
    func startChat() async throws
    func getUserChats() async throws -> [UserEntity]
    func getMessages(interlocutorID: String) async throws -> [ChatMessageEntity]
    func sendMessage(message: ChatMessageEntity) async throws
    func closeConnection()
}

public final class ChatServiceImpl: ChatService, @unchecked Sendable {
    public var handler: ((ChatMessageEntity) -> Void)?
    private let client: Chat_ChatServiceAsyncClientProtocol
    private let channel: GRPCChannel
    private let networkService: NetworkService
    private var chatStream: GRPCAsyncBidirectionalStreamingCall<Chat_ChatMessage, Chat_ChatMessage>!
    private let authService: AuthService

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
            self.client = Chat_ChatServiceAsyncClient(channel: channel, interceptors: nil)
            self.channel = channel
            self.authService = authService
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

public extension ChatServiceImpl {
    func startChat() async throws {
        // Обновляем рефреш токен если это необходимо
        try await networkService.maybeRefreshAccessToken(using: authService)
        var options = networkService.callOptions
        options.timeLimit = .none
        chatStream = client.makeChatCall(callOptions: options)

        try await chatStream.requestStream.send(Chat_ChatMessage())

        for try await message in chatStream.responseStream {
            handler?(
                ChatMessageEntity(
                    id: message.id,
                    text: message.text,
                    interlocutorID: message.interlocutorID,
                    dateCreation: message.dateCreation.date,
                    senderID: message.senderID
                )
            )
        }
    }

    func getMessages(interlocutorID: String) async throws -> [ChatMessageEntity] {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Chat_ChatHistoryRequest.with {
            $0.interlocutorID = interlocutorID
        }

        return try await networkService.performAndLog(
            call: client.chatHistory,
            with: request,
            mapping: { $0.messages.map(ChatMessageEntity.init(from:)) }
        )
    }

    func getUserChats() async throws -> [UserEntity] {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.userChats,
            with: request,
            mapping: { $0.users.map(UserEntity.init(from:)) }
        )
    }

    func sendMessage(message: ChatMessageEntity) async throws {
        let request = Chat_ChatMessage.with {
            $0.interlocutorID = message.interlocutorID
            $0.text = message.text
            $0.dateCreation = Google_Protobuf_Timestamp(date: message.dateCreation)
        }

        try await chatStream.requestStream.send(request)
    }

    func closeConnection() {
        do {
            try channel.close().wait()
            chatStream.cancel()
        } catch {
            Logger.log(kind: .error, error)
        }
    }
}
