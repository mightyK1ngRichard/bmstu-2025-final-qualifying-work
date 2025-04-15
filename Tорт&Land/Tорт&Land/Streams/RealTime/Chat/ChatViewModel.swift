//
//  ChatViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

@Observable
final class ChatViewModel {
    var uiProperties = ChatModel.UIProperties()
    private(set) var currentUser: UserModel
    private(set) var interlocutor: UserModel
    private(set) var messages: [ChatModel.ChatMessage] = []
    private(set) var lastMessageID: String?

    init(
        currentUser: UserModel,
        interlocutor: UserModel
    ) {
        self.currentUser = currentUser
        self.interlocutor = interlocutor
//        self.lastMessageID = messages.last?.id
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
