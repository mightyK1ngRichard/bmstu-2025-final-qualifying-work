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
import DesignSystem
import Core
import GRPC

@Observable
final class RootViewModel: RootDisplayData, RootViewModelOutput, @preconcurrency RootViewModelInput {
    // MARK: Inner values
    var uiProperties = RootModel.UIProperties()

    // MARK: Private(set) values
    private(set) var currentUser: UserModel?
    @ObservationIgnored
    private(set) var cakes: [CakeEntity] = []

    // MARK: Private values
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    private let startScreenControl: StartScreenControl
    private var coordinator: Coordinator!

    init(
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProvider,
        startScreenControl: StartScreenControl
    ) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider
        self.startScreenControl = startScreenControl
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

// MARK: - User Model

extension RootViewModel {

    func fetchUserInfoIfNeeded() {
        // FIXME: Сделать получение юзера из SwiftData
        // currentUser =

        guard currentUser == nil && startScreenControl.screenKind == .cakesList else {
            return
        }

        Task { @MainActor in
            do {
                let result = try await networkManager.profileService.getUserInfo()
                let user = UserModel(from: result.userInfo)
                currentUser = user
                fetchUserAvatar(urlString: result.userInfo.profile.imageURL)
                fetchUserHeaderImage(urlString: result.userInfo.profile.headerImageURL)
                fetchCakesImages(cakes: result.userInfo.previewCakes)
            } catch let grpcError as GRPCStatus {
                if grpcError.code == .unauthenticated {
                    uiProperties.sessionIsExpired = true
                    uiProperties.alert = AlertModel(
                        errorContent: ErrorContent(
                            title: "Session Expired",
                            message: "Your session has expired. Please log in again to continue."
                        ),
                        isShown: true
                    )
                }
            }
        }
    }

}

private extension RootViewModel {

    func fetchUserAvatar(urlString: String?) {
        Task { @MainActor in
            guard let url = urlString else {
                return
            }

            let imageState = await imageProvider.fetchImage(for: url)
            currentUser?.avatarImage = imageState
        }
    }

    func fetchUserHeaderImage(urlString: String?) {
        Task { @MainActor in
            guard let url = urlString else {
                return
            }

            let imageState = await imageProvider.fetchImage(for: url)
            currentUser?.headerImage = imageState
        }
    }

    func fetchCakesImages(cakes: [ProfilePreviewCakeEntity]) {
        for (index, cake) in cakes.enumerated() {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: cake.previewImageURL)
                currentUser?.cakes[safe: index]?.previewImageState = imageState
            }
        }
    }

}

// MARK: - Screens

extension RootViewModel {

    func assemblyChatListErrorView() -> TLErrorView.Configuration {
        .init(kind: .customError("User not found", "Current user not found. Please try again later."))
    }

    func assemblyAuthView() -> AuthView {
        AuthAssembler.assemble(authService: networkManager.authService)
    }

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        CakeDetailsAssembler.assemble(
            cakeModel: model,
            isOwnedByUser: model.seller.id == currentUser?.id,
            cakeService: networkManager.cakeService,
            reviewsService: networkManager.reviewsService,
            rootViewModel: self,
            imageProvider: imageProvider
        )
    }

    func assemblyProfileView(userModel: UserModel) -> ProfileView {
        ProfileAssemler.assemble(
            user: userModel,
            imageProvider: imageProvider,
            networkManager: networkManager,
            isCurrentUser: currentUser?.id == userModel.id,
            rootViewModel: self
        )
    }

    func assemblyOrderView(cakeID: String) -> OrderView {
        OrderAssembler.assemble(
            cakeID: cakeID,
            networkManager: networkManager,
            imageProvider: imageProvider
        )
    }

    @MainActor
    func assemblyCakeListView() -> CakesListView {
        CakesListAssembler.assemble(
            rootViewModel: self,
            cakeService: networkManager.cakeService,
            imageProvider: imageProvider
        )
    }

    func assemblyCategoriesView() -> CategoriesView {
        CategoriesAssembler.assemble(
            cakeProvider: networkManager.cakeService,
            imageProvider: imageProvider
        )
    }

    func assemblyChatListView(userModel: UserModel) -> ChatListView {
        ChatListAssembler.assemble(
            currentUser: userModel,
            imageProvider: imageProvider,
            chatProvider: networkManager.chatService
        )
    }

    func assemblyNotificationsListView() -> NotificationsListView {
        NotificationsListAssembler.assemble(
            networkManager: networkManager,
            imageProvider: imageProvider
        )
    }

    func assemblyProfileView() -> ProfileView {
        ProfileAssemler.assemble(
            user: currentUser,
            imageProvider: imageProvider,
            networkManager: networkManager,
            isCurrentUser: true,
            rootViewModel: self
        )
    }

}

// MARK: - Actions

extension RootViewModel {

    func reloadGetUserInfo() {
        fetchUserInfoIfNeeded()
    }

    func didTapAlertButton() {
        guard uiProperties.sessionIsExpired else { return }

        startScreenControl.update(with: .auth)
    }

}

// MARK: - RootViewModelOutput

extension RootViewModel {

    func updateCurrentUser(_ user: ProfileEntity) {
        currentUser = UserModel(from: .init(from: user))
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
