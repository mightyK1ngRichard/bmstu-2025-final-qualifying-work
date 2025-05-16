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
    static func assemble(
        cakeModel: CakeModel,
        isOwnedByUser: Bool,
        cakeService: CakeService,
        reviewsService: ReviewsService,
        rootViewModel: RootViewModelOutput,
        imageProvider: ImageLoaderProvider
    ) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModel(
            cakeModel: cakeModel,
            isOwnedByUser: isOwnedByUser,
            cakeService: cakeService,
            reviewsService: reviewsService,
            imageProvider: imageProvider,
            rootViewModel: rootViewModel
        )

        return CakeDetailsView(viewModel: viewModel)
    }
}
