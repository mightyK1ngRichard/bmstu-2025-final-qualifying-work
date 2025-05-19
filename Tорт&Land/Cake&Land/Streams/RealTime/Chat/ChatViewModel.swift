//
//  ChatViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftUI
import NetworkAPI
import DesignSystem

@Observable
final class ChatViewModel: ChatDisplayLogic, ChatViewModelInput {
    var uiProperties = ChatModel.UIProperties()
    private(set) var currentUser: UserModel
    private(set) var interlocutor: UserModel
    private(set) var messages: [ChatModel.ChatMessage] = []
    private(set) var lastMessageID: String?
    @ObservationIgnored
    private var chatProvider: ChatService
    @ObservationIgnored
    private var coordinator: Coordinator!

    init(
        currentUser: UserModel,
        interlocutor: UserModel,
        chatProvider: ChatService
    ) {
        self.currentUser = currentUser
        self.interlocutor = interlocutor
        self.chatProvider = chatProvider
    }

    func fetchMessages() {

        chatProvider.handler = { [weak self] message in
            guard let self else { return }

            let isYou = message.senderID == currentUser.id

            messages.append(ChatModel.ChatMessage(
                id: message.id,
                isYou: isYou,
                message: message.text,
                user: isYou ? currentUser : interlocutor,
                time: message.dateCreation.formattedHHmm,
                state: .received
            ))

            lastMessageID = message.id
        }

        Task {
            do {
                try await chatProvider.startChat()
            } catch {
                uiProperties.alert = AlertModel(errorContent: error.readableGRPCContent, isShown: true)
            }
        }
        
        uiProperties.isLoading = true

        Task { @MainActor in
            do {
                let messagesEntities = try await chatProvider.getMessages(interlocutorID: interlocutor.id)
                messages = messagesEntities.map { message in
                    let isYou = message.senderID == currentUser.id
                    return ChatModel.ChatMessage(
                        id: message.id,
                        isYou: isYou,
                        message: message.text,
                        user: isYou ? currentUser : interlocutor,
                        time: message.dateCreation.formattedHHmm,
                        state: .received
                    )
                }
                lastMessageID = messagesEntities.last?.id

                uiProperties.isLoading = false
            } catch {
                uiProperties.alert = AlertModel(errorContent: error.readableGRPCContent, isShown: true)
            }
        }
    }

    func didTapSendMessageButton() {
        let chatModel = ChatMessageEntity(
            id: UUID().uuidString,
            text: uiProperties.messageText,
            interlocutorID: interlocutor.id,
            dateCreation: Date(),
            senderID: currentUser.id
        )

        let newMessage = ChatModel.ChatMessage(
            id: chatModel.id,
            isYou: true,
            message: chatModel.text,
            user: currentUser,
            time: chatModel.dateCreation.formattedHHmm,
            state: .progress
        )

        let index = messages.count
        messages.append(newMessage)
        lastMessageID = newMessage.id
        uiProperties.messageText.removeAll()

        // Отправляем сообщение по сети
        sendMessage(chatModel: chatModel, index: index)
    }

    func sendMessage(chatModel: ChatMessageEntity, index: Int) {
        Task { @MainActor in
            do {
                try await chatProvider.sendMessage(message: chatModel)
                messages[safe: index]?.state = .received
            } catch {
                messages[safe: index]?.state = .error
            }
        }
    }

    func configureInterlocutorAvatar() -> TLImageView.Configuration {
        .init(imageState: interlocutor.avatarImage.imageState)
    }
}

extension ChatViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
