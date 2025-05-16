//
//  ChatListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Core
import DesignSystem

@Observable
final class ChatListViewModel: ChatListDisplayLogic, ChatListViewModelInput, ChatListViewModelOutput {
    var uiProperties = ChatListModel.UIProperties()
    var cells: [ChatListModel.ChatCellModel] {
        uiProperties.searchText.isEmpty
        ? allChatCells
        : allChatCells.filter { $0.user.titleName.lowercased().contains(uiProperties.searchText.lowercased()) }
    }
    private var allChatCells: [ChatListModel.ChatCellModel] = []
    @ObservationIgnored
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
            do {
                let usersEntities = try await chatProvider.getUserChats()
                allChatCells = usersEntities.map(ChatListModel.ChatCellModel.init(from:))
                uiProperties.screenState = .finished

                for (index, userEntity) in usersEntities.enumerated() {
                    fetchUserImage(index: index, urlString: userEntity.imageURL)
                }
            } catch {
                uiProperties.screenState = .error(content: error.readableGRPCContent)
            }
        }
    }

    private func fetchUserImage(index: Int, urlString: String?) {
        Task { @MainActor in
            guard let urlString else {
                allChatCells[safe: index]?.user.avatarImage = .fetched(.uiImage(TLAssets.profile))
                return
            }

            let imageState = await imageProvider.fetchImage(for: urlString)
            allChatCells[safe: index]?.user.avatarImage = imageState
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
            title: model.user.titleName,
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
