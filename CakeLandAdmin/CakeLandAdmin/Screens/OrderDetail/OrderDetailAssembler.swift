//
//  OrderDetailAssembler.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation

final class OrderDetailAssembler {
    static func assemble(
        order: OrderModel,
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProviderImpl
    ) -> OrderDetailView {
        let viewModel = OrderDetailViewModel(order: order, networkManager: networkManager, imageProvider: imageProvider)
        return OrderDetailView(viewModel: viewModel)
    }
}
