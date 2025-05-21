//
//  ProfileProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import DesignSystem
import SwiftData

protocol ProfileDisplayLogic {
    var uiProperties: ProfileModel.UIProperties { get set }
    var user: UserModel? { get }
    var isCurrentUser: Bool { get }
}

protocol ProfileViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator, modelContext: ModelContext)

    func assemblyCreateCakeView() -> CreateProductView
    func assemblySettingsView(userModel: UserModel) -> SettingsView
    func assemblyOrdersView() -> OrderListView
    func assemblyChatView(currentUser: UserModel, interlocutor: UserModel) -> ChatView
    func configureAvatarImage() -> TLImageView.Configuration
    func configureHeaderImage() -> TLImageView.Configuration
    func configureProductCard(for cake: CakeModel) -> TLProductCard.Configuration

    func fetchUserData()

    func didTapLoadSavedData()
    func didTapCreateProduct()
    func didTapOpenOrders()
    func didTapOpenSettings()
    func didTapWriteMessage()
    func didTapCakeLikeButton(cake: CakeModel, isSelected: Bool)
    func didTapCakeCard(with cake: CakeModel)

    func didTapAlertButton()
}
