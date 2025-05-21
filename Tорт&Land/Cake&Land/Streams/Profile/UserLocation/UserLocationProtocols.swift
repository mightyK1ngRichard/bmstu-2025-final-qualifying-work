//
//  UserLocationProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol UserLocationDisplayLogic {
    var uiProperties: UserLocationModel.UIProperties { get set }
}

protocol UserLocationViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
}

protocol UserLocationViewModelOutput {}
