//
//  ChatMessageEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//

import Foundation

public struct ChatMessageEntity: Sendable {
    public let id: String
    public let text: String
    public var senderID: String?
    public let interlocutorID: String
    public let dateCreation: Date

    public init(
        id: String,
        text: String,
        interlocutorID: String,
        dateCreation: Date,
        senderID: String? = nil
    ) {
        self.id = id
        self.text = text
        self.interlocutorID = interlocutorID
        self.dateCreation = dateCreation
        self.senderID = senderID
    }
}

// MARK: - Chat_ChatMessage

extension ChatMessageEntity {
    init(from model: Chat_ChatMessage) {
        self = ChatMessageEntity(
            id: model.id,
            text: model.text,
            interlocutorID: model.interlocutorID,
            dateCreation: model.dateCreation.date,
            senderID: model.senderID
        )
    }
}
