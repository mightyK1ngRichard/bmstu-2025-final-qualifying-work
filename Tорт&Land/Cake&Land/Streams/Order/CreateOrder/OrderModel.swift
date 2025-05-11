//
//  OrderModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

enum OrderModel {}

extension OrderModel {
    struct UIProperties: Hashable {
        var state: ScreenState = .initial
        var isLoading = false
        var openSuccessScreen = false
        var selectedFillingID = ""
        var selectedAddressID: String?
        var selectedWeightMultiplier = 1.0
        var paymentMethod: PaymentMethod = .cash
        var alert = AlertModel()
        var deliveryDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    }

    enum Screens: Hashable {
        case updateAddress(AddressEntity)
        case addAddress
    }
}

// MARK: - PaymentMethod

enum PaymentMethod: String, Hashable, CaseIterable {
    case cash
    case ioMoney = "ЮMoney"
}

extension PaymentMethodEntity {
    init(from model: PaymentMethod) {
        switch model {
        case .cash:
            self = .cash
        case .ioMoney:
            self = .ioMoney
        }
    }
}
