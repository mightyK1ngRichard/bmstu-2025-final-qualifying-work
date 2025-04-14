//
//  NotificationDetailViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class NotificationDetailViewModelMock: NotificationDetailDisplayLogic & NotificationDetailViewModelOutput {
    var uiProperties = NotificationDetailModel.UIProperties()
    private(set) var orderData: NotificationDetailModel.OrderData
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService

    init(
        orderData: NotificationDetailModel.OrderData = MockData.mockOrderPurchaseData,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.orderData = orderData
        self.priceFormatter = priceFormatter
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        orderData.cake.configureDescriptionView(priceFormatter: priceFormatter)
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func didTapCustomerInfo() {}

    func didTapSellerInfo() {}
}

// MARK: - Mock Data

private extension NotificationDetailViewModelMock {
    enum MockData {
        static let mockOrderPurchaseData = NotificationDetailModel.OrderData(
            kind: .purchase(CommonMockData.generateMockUserModel(id: 1, name: "Покупатель #1")),
            cake: CommonMockData.generateMockCakeModel(id: 2),
            notification: .init(
                id: "1",
                title: "Вы купили торт",
                text: "Это просто длинне текст уведомления",
                date: Date().description.toCorrectDate,
                userID: "1",
                sellerID: "2",
                productID: "1"
            ),
            deliveryAddress: "Просто какая-то улица"
        )
    }
}
#endif
