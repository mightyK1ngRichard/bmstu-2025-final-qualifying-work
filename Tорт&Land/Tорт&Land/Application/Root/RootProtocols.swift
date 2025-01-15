//
//  RootProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol RootDisplayLogic: RootViewModelInput {
    var uiProperties: RootModel.UIProperties { get set }
    var screenKind: StartScreenKind { get }
    var activeTab: TabBarItem { get }
}

protocol RootViewModelInput {
    func setEnvironmentObjects(_ coordinator: Coordinator, _ startScreenControl: StartScreenControl)
    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView
    func assemblyProfileView(userModel: UserModel) -> ProfileView
}

protocol RootViewModelOutput {}
