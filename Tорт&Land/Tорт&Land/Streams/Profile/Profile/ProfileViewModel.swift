//
//  ProfileViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation
import NetworkAPI

@Observable
final class ProfileViewModel: ProfileDisplayLogic & ProfileViewModelOutput {
    var uiProperties = ProfileModel.UIProperties()
    private(set) var user: UserModel?
    private(set) var isCurrentUser: Bool
    @ObservationIgnored
    private let rootViewModel: RootViewModel
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let profileService: ProfileGrpcService
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let priceFormatter = PriceFormatterService.shared

    init(
        user: UserModel?,
        imageProvider: ImageLoaderProvider,
        profileService: ProfileGrpcService,
        isCurrentUser: Bool = false,
        rootViewModel: RootViewModel
    ) {
        self.user = user
        self.profileService = profileService
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
                fetchAvatarWithHeaderImage(imageURL: user.imageUrl, headerImageURL: user.headerImageUrl)
                fetchCakesImages(cakes: res.userInfo.previewCakes)
            } catch {
                Logger.log(error)
                uiProperties.screenState = .error(message: error.localizedDescription)
            }
        }
    }

    private func fetchAvatarWithHeaderImage(imageURL: String?, headerImageURL: String?) {
        Task { @MainActor in
            guard let imageURL else {
                user?.avatarImage = .error(.systemImage("person.fill"))
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageURL)
            user?.avatarImage = imageState
        }

        Task { @MainActor in
            guard let headerImageURL else {
                user?.headerImage = .empty
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
        print("[DEBUG]: did tap cake with id=\(cake.id)")
        coordinator?.addScreen(RootModel.Screens.details(cake))
    }

    func didTapCreateProduct() {
        print("[DEBUG]: \(#function)")
    }

    func didTapOpenSettings() {
        print("[DEBUG]: \(#function)")
    }

    func didTapOpenMap() {
        print("[DEBUG]: \(#function)")
    }

    func didTapWriteMessage() {
        print("[DEBUG]: \(#function)")
    }

    func didTapCakeLikeButton(cake: CakeModel, isSelected: Bool) {
        print("[DEBUG]: cake with id=\(cake.id) is \(isSelected ? "liked" : "unliked")")
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
}
