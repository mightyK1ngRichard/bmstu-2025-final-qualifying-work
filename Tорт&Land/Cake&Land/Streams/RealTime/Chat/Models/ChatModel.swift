//
//  ChatModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import UIKit

enum ChatModel {}

extension ChatModel {
    struct UIProperties: Hashable {
        var messageText = ""
        var isLoading = false
        var alert = AlertModel()
    }

    struct ChatMessage: Identifiable, Hashable {
        var id: String
        let isYou: Bool
        let message: String
        let user: UserModel
        let time: String
        var state: MessageState
    }
}

extension ChatModel.ChatMessage {
    enum MessageState: String, Hashable {
        case progress
        case received
        case error
    }
}

extension ChatModel.ChatMessage {
    init(from model: ChatMessageEntity, sender: UserModel, userID: String) {
        self = .init(
            id: model.id,
            isYou: model.senderID == userID,
            message: model.text,
            user: sender,
            time: model.dateCreation.formattedHHmm,
            state: .received
        )
    }
}
