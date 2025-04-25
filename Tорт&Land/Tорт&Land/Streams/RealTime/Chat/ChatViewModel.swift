//
//  ChatViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

@Observable
final class ChatViewModel: ChatDisplayLogic, ChatViewModelOutput, ChatViewModelInput {
    var uiProperties = ChatModel.UIProperties()
    private(set) var currentUser: UserModel
    private(set) var interlocutor: UserModel
    private(set) var messages: [ChatModel.ChatMessage]
    private(set) var lastMessageID: String?
    @ObservationIgnored
    private var chatProvider: ChatService

    init(
        currentUser: UserModel,
        interlocutor: UserModel,
        chatProvider: ChatService,
        messages: [ChatModel.ChatMessage] = []
    ) {
        self.currentUser = currentUser
        self.interlocutor = interlocutor
        self.chatProvider = chatProvider
        self.messages = messages
        self.lastMessageID = messages.last?.id
    }

    func fetchMessages() {
        uiProperties.isLoading = true

        Task {
            try await chatProvider.startChat()
        }

        Task { @MainActor in
            let messagesEntities = try await chatProvider.getMessages(interlocutorID: interlocutor.id)
            lastMessageID = messagesEntities.last?.id
            
            for message in messagesEntities {
                let isYou = message.senderID == currentUser.id
                messages.append(
                    ChatModel.ChatMessage(
                        id: message.id,
                        isYou: isYou,
                        message: message.text,
                        user: isYou ? currentUser : interlocutor,
                        time: message.dateCreation.formattedHHmm,
                        state: .received
                    )
                )
            }

            uiProperties.isLoading = false

            chatProvider.handler = { [weak self] msg in
                guard let self else { return }
                messages.append(
                    ChatModel.ChatMessage(
                        from: msg,
                        sender: msg.senderID == currentUser.id ? currentUser : interlocutor,
                        userID: currentUser.id
                    )
                )
                lastMessageID = msg.id
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
        .init(imageState: interlocutor.avatarImage)
    }
}

extension ChatViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {}
}

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
