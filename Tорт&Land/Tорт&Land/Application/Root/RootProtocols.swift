//
//  RootProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol RootDisplayData {
    var uiProperties: RootModel.UIProperties { get set }
    var screenKind: StartScreenKind { get }
    var activeTab: TabBarItem { get }
    var cakes: [CakeModel] { get }
    var currentUser: UserModel? { get }
}

protocol RootViewModelInput {
    func setEnvironmentObjects(_ coordinator: Coordinator, _ startScreenControl: StartScreenControl)
    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView
    func assemblyProfileView(userModel: UserModel) -> ProfileView
    func assemblyCakeListView() -> CakesListView
    func assemblyCategoriesView() -> CategoriesView
    func assemblyChatListView() -> ChatListView
    func assemblyNotificationsListView() -> NotificationsListView
    func assemblyProfileView() -> ProfileView
}

protocol RootViewModelOutput {
    func setCakes(_ newCakes: [CakeModel])
}
