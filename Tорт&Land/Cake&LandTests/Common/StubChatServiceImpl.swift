//
//  StubChatServiceImpl.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 25.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import NetworkAPI

final class StubChatServiceImpl: ChatService, @unchecked Sendable {
    var handler: ((NetworkAPI.ChatMessageEntity) -> Void)?
    
    func startChat() async throws {
        fatalError("No implementation")
    }
    
    func getUserChats() async throws -> [NetworkAPI.UserEntity] {
        fatalError("No implementation")
    }
    
    func getMessages(interlocutorID: String) async throws -> [NetworkAPI.ChatMessageEntity] {
        fatalError("No implementation")
    }
    
    func sendMessage(message: NetworkAPI.ChatMessageEntity) async throws {
        fatalError("No implementation")
    }
    
    func closeConnection() {
        fatalError("No implementation")
    }
}
