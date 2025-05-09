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
import NetworkAPI

@Observable
final class ProfileViewModel: ProfileDisplayLogic, ProfileViewModelInput, ProfileViewModelOutput {
    var uiProperties = ProfileModel.UIProperties()
    private(set) var user: UserModel?
    private(set) var isCurrentUser: Bool
    @ObservationIgnored
    private let rootViewModel: RootViewModel
    @ObservationIgnored
    private let chatProvider: ChatService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let cakeProvider: CakeService
    @ObservationIgnored
    private let authService: AuthService
    @ObservationIgnored
    private let profileService: ProfileService
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private var orderService: OrderService
    @ObservationIgnored
    private let priceFormatter = PriceFormatterService.shared
    @ObservationIgnored
    private var store: Set<AnyCancellable> = []

    init(
        user: UserModel?,
        imageProvider: ImageLoaderProvider,
        cakeProvider: CakeService,
        chatProvider: ChatService,
        authService: AuthService,
        profileService: ProfileService,
        orderService: OrderService,
        isCurrentUser: Bool = false,
        rootViewModel: RootViewModel
    ) {
        self.user = user
        self.profileService = profileService
        self.cakeProvider = cakeProvider
        self.authService = authService
        self.chatProvider = chatProvider
        self.isCurrentUser = isCurrentUser
        self.orderService = orderService
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
    func fetchUserData() {
        guard isCurrentUser else {
            uiProperties.screenState = .finished
            return
        }

        uiProperties.screenState = .loading
        Task { @MainActor in
            do {
                let res = try await profileService.getUserInfo()
                user = UserModel(from: res.userInfo)
                uiProperties.screenState = .finished
                let user = res.userInfo.profile
                if isCurrentUser {
                    rootViewModel.updateCurrentUser(user)
                }
                fetchAvatarWithHeaderImage(imageURL: user.imageURL, headerImageURL: user.headerImageURL)
                fetchCakesImages(cakes: res.userInfo.previewCakes)
            } catch {
                uiProperties.screenState = .error(message: error.readableGRPCMessage)
            }
        }
    }

    private func fetchAvatarWithHeaderImage(imageURL: String?, headerImageURL: String?) {
        Task { @MainActor in
            guard let imageURL else {
                user?.avatarImage = .fetched(.uiImage(.profile))
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
                user?.cakes[index].previewImageState = imageState
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
        if let interlocutor = user {
            coordinator?.addScreen(ProfileModel.Screens.sendMessage(interlocutor: interlocutor))
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
        CreateProductAssembler.assemble(
            cakeProvider: cakeProvider,
            imageProvider: imageProvider
        )
    }

    func assemblyChatView(interlocutor: UserModel) -> ChatView {
        guard let currentUser = rootViewModel.currentUser else {
            fatalError()
        }

        return ChatAssembler.assemble(
            currentUser: currentUser,
            interlocutor: interlocutor,
            chatProvider: chatProvider
        )
    }

    func assemblySettingsView(userModel: UserModel) -> SettingsView {
        let view = SettingsAssembler.assemble(userModel: userModel, authService: authService, profileProvider: profileService)
        view.viewModel.userPublisher
            .sink { [weak self] updatedUser in
                self?.user = updatedUser
            }
            .store(in: &store)
        return view
    }

    func assemblyOrdersView() -> OrderListView {
        OrderListAssembler.assemble(orderService: orderService)
    }

}
