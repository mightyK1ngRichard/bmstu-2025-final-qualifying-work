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
    static func assemble(orderService: OrderService) -> OrderListView {
        let viewModel = OrderListViewModel(orderService: orderService)
        return OrderListView(viewModel: viewModel)
    }
}
