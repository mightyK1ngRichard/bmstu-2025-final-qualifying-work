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
    private let chatProvider: ChatService

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
        }
    }

    func didTapSendMessageButton() {
//        let newMessage = ChatModel.ChatMessage(
//            id: UUID().uuidString,
//            isYou: true,
//            message: uiProperties.messageText,
//            user: currentUser,
//            time: Date.now.formattedHHmm,
//            state: .received
//        )
//        messages.append(newMessage)
//        uiProperties.messageText.removeAll()
    }

    func configureInterlocutorAvatar() -> TLImageView.Configuration {
        .init(imageState: interlocutor.avatarImage)
    }
}

extension ChatViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {}
}
