//
//  ProfileViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation
import Combine
import Core
import GRPC
import NetworkAPI
import DesignSystem
import SwiftData

@Observable
final class ProfileViewModel: ProfileDisplayLogic, ProfileViewModelInput {
    var uiProperties = ProfileModel.UIProperties()
    private(set) var user: UserModel?
    private(set) var isCurrentUser: Bool
    @ObservationIgnored
    private let rootViewModel: RootViewModel
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private var modelContext: ModelContext?
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let priceFormatter = PriceFormatterService.shared
    @ObservationIgnored
    private var store: Set<AnyCancellable> = []

    init(
        user: UserModel?,
        imageProvider: ImageLoaderProvider,
        networkManager: NetworkManager,
        isCurrentUser: Bool = false,
        rootViewModel: RootViewModel
    ) {
        self.user = user
        self.networkManager = networkManager
        self.isCurrentUser = isCurrentUser
        self.imageProvider = imageProvider
        self.rootViewModel = rootViewModel
    }

    func setEnvironmentObjects(coordinator: Coordinator, modelContext: ModelContext) {
        self.coordinator = coordinator
        self.modelContext = modelContext
    }
}

// MARK: - Network

extension ProfileViewModel {

    func fetchCurrentUserInfo() {
        uiProperties.screenState = .loading

        Task { @MainActor in
            do {
                // Получаем сетевые данные пользователя
                let res = try await networkManager.profileService.getUserInfo()
                let profile = res.userInfo.profile
                var userModel = UserModel(from: profile)
                userModel.cakes = res.userInfo.previewCakes.map(CakeModel.init(from:))
                user = userModel

                // Запоминаем данные текущего пользователя
                if isCurrentUser {
                    rootViewModel.updateCurrentUser(userModel)
                }

                uiProperties.screenState = .finished

                // Получаем изображения
                fetchAvatarWithHeaderImage(imageURL: profile.imageURL, headerImageURL: profile.headerImageURL)
                fetchCakesImages(cakes: res.userInfo.previewCakes)
            } catch {
                // Специфическая логика на "invalid refresh token"
                if let grpcError = error as? GRPCStatus,
                   grpcError.code == .invalidArgument,
                   grpcError.message?.contains("invalid refresh token") == true {
                    uiProperties.sessionExpired = true
                    uiProperties.buttonTitle = StringConstants.logout
                    uiProperties.screenState = .error(
                        content: AlertContent(
                            title: StringConstants.sessionExpiredTitle,
                            message: StringConstants.sessionExpiredSubtitle
                        )
                    )
                    return
                }

                uiProperties.screenState = .error(content: error.readableGRPCContent)
            }
        }
    }

    func fetchInterlocutorInfo(interlocutor: UserModel) {
        Task { @MainActor in
            do {
                // Получаем торты
                let res = try await networkManager.cakeService.getUserCakes(userID: interlocutor.id)
                user?.cakes = res.map(CakeModel.init(from:))
                uiProperties.screenState = .finished

                // Получаем изображения пользователя
                fetchAvatarWithHeaderImage(imageURL: interlocutor.avatarImage.url, headerImageURL: interlocutor.headerImage.url)

                // Получаем изобржения тортов
                for (index, cake) in res.enumerated() {
                    Task { @MainActor in
                        let imageState = await imageProvider.fetchImage(for: cake.imageURL)
                        user?.cakes[safe: index]?.previewImageState = imageState
                    }
                }
            } catch {
                uiProperties.screenState = .error(content: error.readableGRPCContent)
            }
        }
    }

    func fetchUserData() {
        uiProperties.screenState = .loading

        // Если данные опонента
        if let user, !isCurrentUser {
            fetchInterlocutorInfo(interlocutor: user)
            return
        }

        fetchCurrentUserInfo()
    }

    private func fetchAvatarWithHeaderImage(imageURL: String?, headerImageURL: String?) {
        Task { @MainActor in
            guard let imageURL else {
                user?.avatarImage.imageState = .fetched(.uiImage(TLAssets.profile))
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageURL)
            user?.avatarImage.imageState = imageState
        }

        Task { @MainActor in
            guard let headerImageURL else {
                user?.headerImage.imageState = .fetched(.uiImage(.mockHeader))
                return
            }

            let imageState = await imageProvider.fetchImage(for: headerImageURL)
            user?.headerImage.imageState = imageState
        }
    }

    private func fetchCakesImages(cakes: [ProfilePreviewCakeEntity]) {
        for (index, cake) in cakes.enumerated() {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: cake.previewImageURL)
                user?.cakes[safe: index]?.previewImageState = imageState
            }
        }
    }

}

// MARK: - Memory

private extension ProfileViewModel {

    @MainActor
    func fetchUserFromMemory(userID: String) async throws -> (UserEntity, [PreviewCakeEntity])? {
        guard let modelContext else {
            return nil
        }

        guard
            let sdUser = try await SDMemoryManager.shared.fetchUserFromMemory(userID: userID, using: modelContext)
        else { return nil }

        let previewCakes = sdUser.cakes.compactMap(\.asPreviewEntity)
        let user = sdUser.asEntity

        return (user, previewCakes)
    }

}

// MARK: - Actions

extension ProfileViewModel {

    func didTapLoadSavedData() {
        Task { @MainActor in
            uiProperties.screenState = .loading

            // TODO: Если это текущий пользователь, надо достать ID
            guard let userID = user?.id,
                  let savedData = try? await fetchUserFromMemory(userID: userID) else {
                uiProperties.screenState = .error(
                    content: AlertContent(title: StringConstants.userNotFound, message: StringConstants.userHasNotBeenCached)
                )
                return
            }

            let userEntity = savedData.0
            let userCakes = savedData.1
            var tempUser = UserModel(from: userEntity)
            tempUser.cakes = userCakes.map(CakeModel.init(from:))
            user = tempUser

            uiProperties.screenState = .finished

            // Получаем изображения
            fetchAvatarWithHeaderImage(imageURL: userEntity.imageURL, headerImageURL: userEntity.headerImageURL)
            for (index, cake) in userCakes.enumerated() {
                Task { @MainActor in
                    let imageState = await imageProvider.fetchImage(for: cake.imageURL)
                    user?.cakes[safe: index]?.previewImageState = imageState
                }
            }
        }
    }

    func didTapCakeCard(with cake: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(cake))
    }

    func didTapCreateProduct() {
        coordinator?.addScreen(ProfileModel.Screens.createProfile)
    }

    func didTapOpenSettings() {
        if let userModel = user {
            coordinator?.addScreen(ProfileModel.Screens.settings(userModel: userModel))
        }
    }

    func didTapAlertButton() {
        // Если устарела сессия, надо разлогиниться
        guard !uiProperties.sessionExpired else {
            rootViewModel.startScreenControl.update(with: .auth)
            return
        }

        // Иначе тянем данные
        fetchUserData()
    }

    func didTapWriteMessage() {
        if let interlocutor = user, let currentUser = rootViewModel.currentUser {
            coordinator?.addScreen(ProfileModel.Screens.sendMessage(currentUser: currentUser, interlocutor: interlocutor))
        } else {
            uiProperties.alert = AlertModel(
                content: AlertContent(
                    title: StringConstants.currentUserNotFound,
                    message: StringConstants.innerError
                ),
                isShown: true
            )
        }
    }

    func didTapCakeLikeButton(cake: CakeModel, isSelected: Bool) {
        print("[DEBUG]: cake with id=\(cake.id) is \(isSelected ? "liked" : "unliked")")
    }

    func didTapOpenOrders() {
        coordinator?.addScreen(ProfileModel.Screens.orders)
    }

}

// MARK: - Configurations

extension ProfileViewModel {

    func configureAvatarImage() -> TLImageView.Configuration {
        guard let user else { return .init(imageState: .loading) }
        return .init(imageState: user.avatarImage.imageState)
    }

    func configureHeaderImage() -> TLImageView.Configuration {
        guard let user else { return .init(imageState: .loading) }
        return .init(imageState: user.headerImage.imageState)
    }

    func configureProductCard(for cake: CakeModel) -> TLProductCard.Configuration {
        cake.configureProductCard(priceFormatter: priceFormatter)
    }

    func assemblyCreateCakeView() -> CreateProductView {
        let view = CreateProductAssembler.assemble(
            cakeProvider: networkManager.cakeService,
            imageProvider: imageProvider
        )
        view.viewModel.createPublisher
            .sink { [weak self] createdCake in
                guard let self,
                      let userModel = user
                else { return }
                user?.cakes.append(CakeModel(from: createdCake, user: userModel))
            }
            .store(in: &store)


        return view
    }

    func assemblyChatView(currentUser: UserModel, interlocutor: UserModel) -> ChatView {
        ChatAssembler.assemble(
            currentUser: currentUser,
            interlocutor: interlocutor,
            chatProvider: networkManager.chatService
        )
    }

    func assemblySettingsView(userModel: UserModel) -> SettingsView {
        let view = SettingsAssembler.assemble(
            userModel: userModel,
            networkManager: networkManager,
            rootViewModel: rootViewModel
        )
        view.viewModel.userPublisher
            .sink { [weak self] updatedUser in
                self?.user = updatedUser
            }
            .store(in: &store)
        return view
    }

    func assemblyOrdersView() -> OrderListView {
        OrderListAssembler.assemble(
            cakeService: networkManager.cakeService,
            orderService: networkManager.orderService,
            imageProvider: imageProvider,
            priceFormatter: priceFormatter
        )
    }

}
