//
//  OrderModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftUI
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

enum PaymentMethod: Hashable, CaseIterable {
    case cash

    var localizedName: String {
        switch self {
        case .cash:
            return String(localized: "Cash")
        }
    }
}

extension PaymentMethodEntity {
    init(from model: PaymentMethod) {
        switch model {
        case .cash:
            self = .cash
        }
    }
}

// MARK: - OrderStatusEntity

extension OrderStatusEntity {
    var title: String {
        switch self {
        case .pending:
            return String(localized: "Pending")
        case .shipped:
            return String(localized: "Shipped")
        case .delivered:
            return String(localized: "Delivered")
        case .cancelled:
            return String(localized: "Cancelled")
        }
    }

    /// Цвет текста статуса
    var textColor: Color {
        switch self {
        case .pending:
            return .orange
        case .shipped:
            return .blue
        case .delivered:
            return .green
        case .cancelled:
            return .red
        }
    }
}

