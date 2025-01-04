//
//  ChatViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class ChatViewModelMock: ChatDisplayLogic & ChatViewModelOutput {
    var uiProperties = ChatModel.UIProperties()
    private(set) var currentUser: UserModel
    private(set) var messages: [ChatModel.ChatMessage]
    private(set) var lastMessageID: String?

    init(
        currentUser: UserModel = MockData.mockCurrentUser,
        messages: [ChatModel.ChatMessage] = MockData.mockMessages
    ) {
        self.currentUser = currentUser
        self.messages = messages
        self.lastMessageID = messages.last?.id
    }

    func setEnvironmentObjects(coordinator: Coordinator) {}

    func didTapSendMessageButton() {
        let newMessage = ChatModel.ChatMessage(
            id: UUID().uuidString,
            isYou: true,
            message: uiProperties.messageText,
            user: currentUser,
            time: Date.now.description,
            state: .received
        )
        messages.append(newMessage)
    }
}

private extension ChatViewModelMock {
    enum MockData {
        static let mockCurrentUser = CommonMockData.generateMockUserModel(id: 1, name: "Пермяков Дмитрий", avatar: .fetched(.uiImage(.king)))
        static let mockMessages: [ChatModel.ChatMessage] = (1...20).map {
            ChatModel.ChatMessage(
                id: String($0),
                isYou: Bool.random(),
                message: "Просто моковое сообщение \($0)",
                user: CommonMockData.generateMockUserModel(id: 1),
                time: "13:21",
                state: .received
            )
        }
    }
}
#endif
