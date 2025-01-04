//
//  RootViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class RootViewModelMock: RootDisplayLogic & RootViewModelOutput {
    var uiProperties = RootModel.UIProperties()

    func setEnvironmentObjects(coordinator: Coordinator) {}

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModelMock(cakeModel: model)
        return CakeDetailsView(viewModel: viewModel)
    }
}

#endif
