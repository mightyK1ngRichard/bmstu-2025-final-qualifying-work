//
//  RootProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftUI
import NetworkAPI

protocol RootDisplayData {
    var uiProperties: RootModel.UIProperties { get set }
    var screenKind: StartScreenKind { get }
    var activeTab: TabBarItem { get }
    var cakes: [CakeEntity] { get }
    var currentUser: UserModel? { get }
}

protocol RootViewModelInput {
    func fetchUserInfoIfNeeded()
    func reloadGetUserInfo()

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView
    func assemblyProfileView(userModel: UserModel) -> ProfileView
    func assemblyOrderView(cakeID: String) -> OrderView
    func assemblyAuthView() -> AuthView
    func assemblyCakeListView() -> CakesListView
    func assemblyCategoriesView() -> CategoriesView
    func assemblyChatListErrorView() -> TLErrorView.Configuration
    func assemblyChatListView(userModel: UserModel) -> ChatListView
    func assemblyNotificationsListView() -> NotificationsListView
    func assemblyProfileView() -> ProfileView

    func setEnvironmentObjects(_ coordinator: Coordinator)
}

protocol RootViewModelOutput {
    func setCakes(_ newCakes: [CakeEntity])
    func updateCake(_ cake: CakeEntity)
}
