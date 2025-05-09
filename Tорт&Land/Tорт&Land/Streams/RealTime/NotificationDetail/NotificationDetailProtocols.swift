//
//  NotificationDetailProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import DesignSystem

protocol NotificationDetailDisplayLogic: NotificationDetailViewModelInput {
    var uiProperties: NotificationDetailModel.UIProperties { get set }
    var orderData: NotificationDetailModel.OrderData { get }
}

protocol NotificationDetailViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration
}

protocol NotificationDetailViewModelOutput {
    func didTapCustomerInfo()
    func didTapSellerInfo()
}
