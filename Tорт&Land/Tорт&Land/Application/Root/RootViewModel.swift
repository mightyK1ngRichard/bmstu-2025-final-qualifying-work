//
//  RootViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftUI
import NetworkAPI
import Observation

@Observable
final class RootViewModel: RootDisplayData & RootViewModelOutput {
    // MARK: Inner values
    var uiProperties = RootModel.UIProperties()

    // MARK: Computed values
    var screenKind: StartScreenKind {
        startScreenControl?.screenKind ?? .initial
    }
    var activeTab: TabBarItem {
        coordinator?.activeTab ?? .house
    }

    // MARK: Private values
    private(set) var currentUser: UserModel?
    private var startScreenControl: StartScreenControl?
    @ObservationIgnored
    private let cakeService: CakeGrpcService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(cakeService: CakeGrpcService, imageProvider: ImageLoaderProvider) {
        self.cakeService = cakeService
        self.imageProvider = imageProvider
        // FIXME: Сделать UserDefauls
        // currentUser = UserDefaults
    }
}

// MARK: - Screens

extension RootViewModel: @preconcurrency RootViewModelInput {
    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        CakeDetailsAssembler.assemble(
            cakeModel: model,
            isOwnedByUser: model.seller.id == currentUser?.id,
            cakeService: cakeService,
            imageProvider: imageProvider
        )
    }

    func assemblyProfileView(userModel: UserModel) -> ProfileView {
        // FIXME: Заменить моки
        let viewModel = ProfileViewModelMock(user: userModel, isCurrentUser: userModel.id == currentUser?.id)
        return ProfileView(viewModel: viewModel)
    }

    @MainActor
    func assemblyCakeListView() -> CakesListView {
        CakesListAssembler.assemble(cakeService: cakeService, imageProvider: imageProvider)
    }

    func assemblyCategoriesView() -> CategoriesView {
        // FIXME: Убрать моки
        let viewModel = CategoriesViewModelMock()
        return CategoriesView(viewModel: viewModel)
    }

    func assemblyChatListView() -> ChatListView {
        // FIXME: Убрать моки
        let viewModel = ChatListViewModelMock(delay: 3)
        return ChatListView(viewModel: viewModel)
    }

    func assemblyNotificationsListView() -> NotificationsListView {
        // FIXME: Убрать моки
        let viewModel = NotificationsListViewModelMock(delay: 3)
        return NotificationsListView(viewModel: viewModel)
    }

    func assemblyProfileView() -> ProfileView {
        // FIXME: Убрать моки
        let viewModel = ProfileViewModelMock(isCurrentUser: true)
        return ProfileView(viewModel: viewModel)
    }
}

// MARK: - Setters

extension RootViewModel {
    func setEnvironmentObjects(_ coordinator: Coordinator, _ startScreenControl: StartScreenControl) {
        if self.coordinator == nil {
            self.coordinator = coordinator
        }

        if self.startScreenControl == nil {
            self.startScreenControl = startScreenControl
        }
    }
}
