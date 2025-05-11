//
//  OrderDetailsAssemler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 10.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class OrderDetailsAssemler {
    static func assemble(
        orderEntity: OrderEntity,
        cakeService: CakeService,
        imageProvider: ImageLoaderProvider
    ) -> OrderDetailsView {
        let viewModel = OrderDetailsViewModel(
            orderEntity: orderEntity,
            cakeService: cakeService,
            imageProvider: imageProvider
        )

        return OrderDetailsView(viewModel: viewModel)
    }
}
