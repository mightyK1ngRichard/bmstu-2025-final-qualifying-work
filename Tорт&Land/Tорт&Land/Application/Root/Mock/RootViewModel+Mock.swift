//
//  RootViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class RootViewModelMock: RootDisplayData {
    // Inner values
    var uiProperties = RootModel.UIProperties()

    // Computed values
    var screenKind: StartScreenKind {
        startScreenControl?.screenKind ?? .initial
    }
    var activeTab: TabBarItem {
        coordinator?.activeTab ?? .house
    }

    // Private values
    private(set) var cakes: [CakeModel] = []
    private(set) var currentUser: UserModel?
    private var startScreenControl: StartScreenControl?
    private var coordinator: Coordinator?

    init(currentUser: UserModel = MockData.mockCurrentUser) {
        self.currentUser = currentUser
    }

    func setEnvironmentObjects(_ coordinator: Coordinator, _ startScreenControl: StartScreenControl) {
        self.coordinator = coordinator
        self.startScreenControl = startScreenControl
    }
}

// MARK: - Screens

extension RootViewModelMock: @preconcurrency RootViewModelInput {
    @MainActor
    func assemblyCakeListView() -> CakesListView {
        CakesListAssembler.assembleMock()
    }

    func assemblyCategoriesView() -> CategoriesView {
        // FIXME: Assembler моки
        let viewModel = CategoriesViewModelMock()
        return CategoriesView(viewModel: viewModel)
    }

    func assemblyChatListView() -> ChatListView {
        // FIXME: Assembler моки
        let viewModel = ChatListViewModelMock(delay: 3)
        return ChatListView(viewModel: viewModel)
    }

    func assemblyNotificationsListView() -> NotificationsListView {
        // FIXME: Assembler моки
        let viewModel = NotificationsListViewModelMock(delay: 3)
        return NotificationsListView(viewModel: viewModel)
    }

    func assemblyProfileView() -> ProfileView {
        // FIXME: Assembler моки
        let viewModel = ProfileViewModelMock(user: currentUser, isCurrentUser: true)
        return ProfileView(viewModel: viewModel)
    }

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        CakeDetailsAssembler.assembleMock(cakeModel: model)
    }

    func assemblyProfileView(userModel: UserModel) -> ProfileView {
        let viewModel = ProfileViewModelMock(user: userModel, isCurrentUser: userModel.id == currentUser?.id)
        return ProfileView(viewModel: viewModel)
    }
}

// MARK: - Mock Data

private extension RootViewModelMock {
    enum MockData {
        static let mockCurrentUser = CommonMockData.generateMockUserModel(
            id: 1,
            name: "Дмитрий Пермяков",
            avatar: .fetched(.uiImage(.king))
        )
    }
}

#endif
