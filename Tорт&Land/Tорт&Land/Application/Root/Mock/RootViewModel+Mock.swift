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
    private(set) var currentUser: UserModel

    init(currentUser: UserModel = MockData.mockCurrentUser) {
        self.currentUser = currentUser
    }

    func setEnvironmentObjects(coordinator: Coordinator) {}

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModelMock(cakeModel: model)
        return CakeDetailsView(viewModel: viewModel)
    }

    func assemblyProfileView(userModel: UserModel) -> ProfileView {
        let viewModel = ProfileViewModelMock(user: userModel, isCurrentUser: userModel.id == currentUser.id)
        return ProfileView(viewModel: viewModel)
    }
}

// MARK: - Mock Data

private extension RootViewModelMock {
    enum MockData {
        static let mockCurrentUser = CommonMockData.generateMockUserModel(
            id: 1,
            name: "Дмитрий Пермяков",
            avatar: .fetched(.uiImage(.king))
        )
    }
}

#endif
