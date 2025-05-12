//
//  OrdersListModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import NetworkAPI

enum OrdersListModel {}

extension OrdersListModel {
    struct BindingData: Hashable {
        var state: ScreenState = .initial
        var alert = AlertModel()
        var saveButtonIsLoading = false
        var allStatuses: [OrderStatusEntity] = OrderStatusEntity.allCases
        var selectedOrder: String?
    }

    enum Screens: Hashable {
        case order(OrderModel)
    }
}
