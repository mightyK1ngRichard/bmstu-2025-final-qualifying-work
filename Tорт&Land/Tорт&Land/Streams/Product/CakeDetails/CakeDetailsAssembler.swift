//
//  CakeDetailsAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class CakeDetailsAssembler {
    static func assemble(cakeModel: CakeModel, isOwnedByUser: Bool, cakeService: CakeGrpcService) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModel(
            cakeModel: cakeModel,
            isOwnedByUser: isOwnedByUser,
            cakeService: cakeService
        )
        return CakeDetailsView(viewModel: viewModel)
    }

    static func assembleMock(cakeModel: CakeModel) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModelMock(isOwnedByUser: false, cakeModel: cakeModel)
        return CakeDetailsView(viewModel: viewModel)
    }
}
