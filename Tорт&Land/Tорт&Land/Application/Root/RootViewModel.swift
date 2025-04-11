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
final class RootViewModel: RootDisplayData, RootViewModelOutput {
    // MARK: Inner values
    var uiProperties = RootModel.UIProperties()

    // MARK: Private(set) values
    private(set) var currentUser: UserModel?
    @ObservationIgnored
    private(set) var cakes: [CakeEntity] = []

    // MARK: Private values
    private let startScreenControl: StartScreenControl
    @ObservationIgnored
    private let authService: AuthService
    @ObservationIgnored
    private let cakeService: CakeGrpcService
    @ObservationIgnored
    private let profileService: ProfileGrpcService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    private var coordinator: Coordinator!

    init(
        authService: AuthService,
        cakeService: CakeGrpcService,
        profileService: ProfileGrpcService,
        imageProvider: ImageLoaderProvider,
        startScreenControl: StartScreenControl
    ) {
        self.authService = authService
        self.cakeService = cakeService
        self.profileService = profileService
        self.imageProvider = imageProvider
        self.startScreenControl = startScreenControl
        // FIXME: Сделать UserDefauls
        // currentUser = UserDefaults
    }
}

extension RootViewModel {
    var screenKind: StartScreenKind {
        startScreenControl.screenKind
    }

    var activeTab: TabBarItem {
        coordinator?.activeTab ?? .house
    }
}

// MARK: - Screens

extension RootViewModel: @preconcurrency RootViewModelInput {
    func assemblyAuthView() -> AuthView {
        AuthAssembler.assemble(authService: authService)
    }

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        CakeDetailsAssembler.assemble(
            cakeModel: model,
            isOwnedByUser: model.seller.id == currentUser?.id,
            cakeService: cakeService,
            rootViewModel: self,
            imageProvider: imageProvider
        )
    }

    func assemblyProfileView(userModel: UserModel) -> ProfileView {
        ProfileAssemler.assemble(
            user: userModel,
            imageProvider: imageProvider,
            profileService: profileService,
            isCurrentUser: currentUser?.id == userModel.id
        )
    }

    @MainActor
    func assemblyCakeListView() -> CakesListView {
        CakesListAssembler.assemble(
            rootViewModel: self,
            cakeService: cakeService,
            imageProvider: imageProvider
        )
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
        ProfileAssemler.assemble(
            user: currentUser,
            imageProvider: imageProvider,
            profileService: profileService,
            isCurrentUser: true
        )
    }
}

// MARK: - RootViewModelOutput

extension RootViewModel {

    func updateCurrentUser(_ user: UserEntity) {
        #warning("Сделать из экрана профиля")
    }

    func setCakes(_ newCakes: [CakeEntity]) {
        var newCakesDict = Dictionary(uniqueKeysWithValues: newCakes.map { ($0.id, $0) })

        // Обновляем существующие торты
        for (index, cake) in cakes.enumerated() {
            if let newCake = newCakesDict[cake.id] {
                if newCake != cake {
                    cakes[index] = newCake
                }
                newCakesDict.removeValue(forKey: cake.id)
            }
        }

        // Добавляем новые торты
        cakes.append(contentsOf: newCakesDict.values)

        // TODO: Сделать кэширование в SwiftData
    }

    func updateCake(_ cake: CakeEntity) {
        guard let index = cakes.firstIndex(where: { $0.id == cake.id }) else {
            return
        }

        if cakes[index] != cake {
            cakes[index] = cake
        }

        // TODO: Сделать кэширование в SwiftData
    }

}

// MARK: - Setters

extension RootViewModel {
    func setEnvironmentObjects(_ coordinator: Coordinator) {
        if self.coordinator == nil {
            self.coordinator = coordinator
        }
    }
}
