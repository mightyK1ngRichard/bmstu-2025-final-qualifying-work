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
    // Inner values
    var uiProperties = RootModel.UIProperties()
    // Computed values
    var screenKind: StartScreenKind {
        startScreenControl?.screenKind ?? .initial
    }
    var activeTab: TabBarItem {
        coordinator?.activeTab ?? .house
    }
    // Private values
    private(set) var currentUser: UserModel
    private var startScreenControl: StartScreenControl?
    private var coordinator: Coordinator?

    init(currentUser: UserModel = MockData.mockCurrentUser) {
        self.currentUser = currentUser
    }

    func setEnvironmentObjects(_ coordinator: Coordinator, _ startScreenControl: StartScreenControl) {
        self.coordinator = coordinator
        self.startScreenControl = startScreenControl
    }

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
