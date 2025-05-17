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

@Observable
final class ProfileViewModel: ProfileDisplayLogic, ProfileViewModelInput, ProfileViewModelOutput {
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

    func setEnvironmentObjects(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }
}

// MARK: - Network

extension ProfileViewModel {

    func fetchCurrentUserInfo() {
        Task { @MainActor in
            do {
                // Получаем данные пользователя
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

                // Получаем изображения пользователя
                fetchAvatarWithHeaderImage(imageURL: profile.imageURL, headerImageURL: profile.headerImageURL)

                // Получаем изображения тортов
                fetchCakesImages(cakes: res.userInfo.previewCakes)
            } catch {
                uiProperties.screenState = .error(content: error.readableGRPCContent)
            }
        }
    }

    func fetchInterlocutorInfo(interlocutorID: String) {
        Task { @MainActor in
            do {
                // Получаем торты
                let res = try await networkManager.cakeService.getUserCakes(userID: interlocutorID)
                user?.cakes = res.map(CakeModel.init(from:))
                uiProperties.screenState = .finished

                // Получаем изобржения тортов
                for (index, cake) in res.enumerated() {
                    Task { @MainActor in
                        let imageState = await imageProvider.fetchImage(for: cake.imageURL)
                        user?.cakes[safe: index]?.previewImageState = imageState
                    }
                }
            } catch {
                uiProperties.alert = AlertModel(errorContent: error.readableGRPCContent, isShown: true)
            }
        }
    }

    func fetchUserData() {
        uiProperties.screenState = .loading

        // Если данные опонента
        if let user, !isCurrentUser {
            fetchInterlocutorInfo(interlocutorID: user.id)
            return
        }

        fetchCurrentUserInfo()
    }

    private func fetchAvatarWithHeaderImage(imageURL: String?, headerImageURL: String?) {
        Task { @MainActor in
            guard let imageURL else {
                user?.avatarImage = .fetched(.uiImage(TLAssets.profile))
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageURL)
            user?.avatarImage = imageState
        }

        Task { @MainActor in
            guard let headerImageURL else {
                user?.headerImage = .fetched(.uiImage(.mockHeader))
                return
            }

            let imageState = await imageProvider.fetchImage(for: headerImageURL)
            user?.headerImage = imageState
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

// MARK: - Actions

extension ProfileViewModel {

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

    func didTapOpenMap() {
        print("[DEBUG]: \(#function)")
    }

    func didTapWriteMessage() {
        if let interlocutor = user, let currentUser = rootViewModel.currentUser {
            coordinator?.addScreen(ProfileModel.Screens.sendMessage(currentUser: currentUser, interlocutor: interlocutor))
        } else {
            uiProperties.alert = AlertModel(
                errorContent: ErrorContent(
                    title: "Current user not found",
                    message: "Inner error. Relaunch this app"
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
        return .init(imageState: user.avatarImage)
    }

    func configureHeaderImage() -> TLImageView.Configuration {
        guard let user else { return .init(imageState: .loading) }
        return .init(imageState: user.headerImage)
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
