//
//  RootAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

final class RootAssembler {
    static func assemble() -> RootView {
        let viewModel = RootViewModel()
        return RootView(viewModel: viewModel)
    }

    static func assembleMock() -> RootView {
        let viewModel = RootViewModelMock()
        return RootView(viewModel: viewModel)
    }
}
