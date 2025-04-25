//
//  ProfileViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class ProfileViewModelMock: ProfileDisplayLogic, ProfileViewModelInput, ProfileViewModelOutput {
    var uiProperties = ProfileModel.UIProperties()
    private(set) var user: UserModel?
    private(set) var isCurrentUser: Bool
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let priceFormatter = PriceFormatterService.shared

    init(user: UserModel? = nil, isCurrentUser: Bool = false) {
        var userInfo = CommonMockData.generateMockUserModel(
            id: 1,
            name: "Пермяков Дмитрий",
            avatar: .fetched(.uiImage(.king)),
            header: .fetched(.uiImage(.headerKing))
        )
        userInfo.cakes = (1...10).map {
            var cake = CommonMockData.generateMockCakeModel(id: $0)
            cake.seller = user ?? userInfo
            return cake
        }
        self.user = user ?? userInfo
        self.isCurrentUser = isCurrentUser
        print("[DEBUG]: isCurrentUser=\(isCurrentUser)")
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Actions

extension ProfileViewModelMock {
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

    func fetchUserData() {
        Task {
            try await Task.sleep(for: .seconds(2))
            uiProperties.screenState = .finished
        }
    }
}

// MARK: - Configurations

extension ProfileViewModelMock {
    func configureAvatarImage() -> TLImageView.Configuration {
        .init(imageState: user!.avatarImage)
    }

    func configureHeaderImage() -> TLImageView.Configuration {
        .init(imageState: user!.headerImage)
    }

    func configureProductCard(for cake: CakeModel) -> TLProductCard.Configuration {
        cake.configureProductCard(priceFormatter: priceFormatter)
    }

    func assemblyCreateCakeView() -> CreateProductView {
        fatalError("init(coder:) has not been implemented")
    }

    func assemblyChatView(interlocutor: UserModel) -> ChatView {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
