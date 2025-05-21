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
        cake: CakeModel,
        isOwnedByUser: Bool,
        cakeService: CakeService,
        reviewsService: ReviewsService,
        imageProvider: ImageLoaderProvider
    ) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModel(
            cake: cake,
            isOwnedByUser: isOwnedByUser,
            cakeService: cakeService,
            reviewsService: reviewsService,
            imageProvider: imageProvider
        )

        return CakeDetailsView(viewModel: viewModel)
    }
}
