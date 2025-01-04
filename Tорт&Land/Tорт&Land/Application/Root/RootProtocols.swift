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
}

protocol RootViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView
}

protocol RootViewModelOutput {}
