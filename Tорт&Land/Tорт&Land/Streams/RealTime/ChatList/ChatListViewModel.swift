//
//  ChatListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

@Observable
final class ChatListViewModel: ChatListDisplayLogic, ChatListViewModelInput, ChatListViewModelOutput {
    var uiProperties = ChatListModel.UIProperties()
    var cells: [ChatListModel.ChatCellModel] {
        uiProperties.searchText.isEmpty
        ? allChatCells
        : allChatCells.filter { $0.user.name.contains(uiProperties.searchText) }
    }
    private var allChatCells: [ChatListModel.ChatCellModel] = []
    private let currentUser: UserModel
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let chatProvider: ChatService
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        currentUser: UserModel,
        imageProvider: ImageLoaderProvider,
        chatProvider: ChatService
    ) {
        self.currentUser = currentUser
        self.imageProvider = imageProvider
        self.chatProvider = chatProvider
    }
}

// MARK: - Network

extension ChatListViewModel {
    func fetchChatsHistory() {
        uiProperties.screenState = .loading
        Task { @MainActor in
            let usersEntities = try await chatProvider.getUserChats()
            for (index, usersEntity) in usersEntities.enumerated() {
                let cell = ChatListModel.ChatCellModel(
                    id: UUID().uuidString,
                    user: UserModel(from: usersEntity),
                    lastMessage: "Последнее сообщение",
                    timeMessage: Date()
                )
                allChatCells.append(cell)
                fetchUserImage(index: index, urlString: usersEntity.imageURL)
            }

            uiProperties.screenState = .finished
        }
    }

    private func fetchUserImage(index: Int, urlString: String?) {
        guard index < allChatCells.count else {
            Logger.log(kind: .error, "index out of range")
            return
        }

        Task { @MainActor in
            guard let urlString else {
                allChatCells[index].user.avatarImage = .fetched(.uiImage(.profile))
                return
            }

            let imageState = await imageProvider.fetchImage(for: urlString)
            allChatCells[index].user.avatarImage = imageState
        }
    }
}

// MARK: - Actions

extension ChatListViewModel {
    func didTapCell(cell: ChatListModel.ChatCellModel) {
        coordinator?.addScreen(ChatListModel.Screens.chat(cell))
    }
}

// MARK: - Configurations

extension ChatListViewModel {
    func configureChatView(with model: ChatListModel.ChatCellModel) -> ChatView {
        ChatAssembler.assemble(
            currentUser: currentUser,
            interlocutor: model.user,
            chatProvider: chatProvider
        )
    }

    func configureChatCell(with model: ChatListModel.ChatCellModel) -> TLChatCell.Configuration {
        .basic(
            imageState: model.user.avatarImage,
            title: model.user.name,
            subtitle: model.lastMessage,
            time: model.timeMessage.formattedHHmm
        )
    }
}

extension ChatListViewModel {
    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
