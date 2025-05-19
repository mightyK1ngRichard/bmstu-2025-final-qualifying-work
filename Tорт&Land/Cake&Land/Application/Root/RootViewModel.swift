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

    // MARK: Private values
    @ObservationIgnored
    private var networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    let startScreenControl: StartScreenControl
    private var coordinator: Coordinator!

    @MainActor
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

    @MainActor
    func updateNetworkManager() {
        self.networkManager = NetworkManager()
    }

}

// MARK: - User Model

extension RootViewModel {

    func fetchUserInfoIfNeeded() {
        // FIXME: Сделать получение юзера из SwiftData
        // currentUser =

        guard currentUser == nil else {
            return
        }

        Task { @MainActor in
            do {
                let result = try await networkManager.profileService.getUserInfo()
                let user = UserModel(from: result.userInfo)
                currentUser = user
                fetchCakesImages(cakes: result.userInfo.previewCakes)
            } catch let grpcError as GRPCStatus {
                if grpcError.code == .unauthenticated {
                    uiProperties.sessionIsExpired = true
                    uiProperties.alert = AlertModel(
                        errorContent: ErrorContent(
                            title: StringConstants.sessionExpiredTitle,
                            message: StringConstants.sessionExpiredSubtitle
                        ),
                        isShown: true
                    )
                }
            }
        }
    }

}

private extension RootViewModel {

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
        .init(
            kind: .customError(StringConstants.currentUserNotFound, StringConstants.currentUserNotFoundSubtitle),
            buttonTitle: StringConstants.tryAgain
        )
    }

    func assemblyAuthView() -> AuthView {
        AuthAssembler.assemble(authService: networkManager.authService)
    }

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        CakeDetailsAssembler.assemble(
            cake: model,
            isOwnedByUser: model.seller.id == currentUser?.id,
            cakeService: networkManager.cakeService,
            reviewsService: networkManager.reviewsService,
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

    func assemblyProfileView() -> ProfileView {
        ProfileAssemler.assemble(
            user: currentUser,
            imageProvider: imageProvider,
            networkManager: networkManager,
            isCurrentUser: true,
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

    @MainActor
    func updateCurrentUser(_ user: UserModel?) {
        currentUser = user
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
