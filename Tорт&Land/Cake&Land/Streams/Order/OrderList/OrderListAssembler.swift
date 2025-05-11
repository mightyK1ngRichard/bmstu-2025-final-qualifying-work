//
//  OrderListAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class OrderListAssembler {
    static func assemble(
        cakeService: CakeService,
        orderService: OrderService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) -> OrderListView {
        let viewModel = OrderListViewModel(
            cakeService: cakeService,
            orderService: orderService,
            imageProvider: imageProvider,
            priceFormatter: priceFormatter
        )
        return OrderListView(viewModel: viewModel)
    }
}
