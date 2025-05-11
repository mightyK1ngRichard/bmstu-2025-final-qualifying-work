//
//  OrderListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

enum OrderListModel {}

extension OrderListModel {
    struct UIProperties: Hashable {
        var state: ScreenState = .initial
    }

    enum Screens: Hashable {
        case orderDetails(order: OrderEntity)
    }
}
