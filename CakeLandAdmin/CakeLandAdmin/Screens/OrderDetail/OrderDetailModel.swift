//
//  OrderDetailModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation

enum OrderDetailModel {}

extension OrderDetailModel {
    struct BindingData: Hashable {
        var alert = AlertModel()
        var isLoading = false
    }
}
