//
//  OrdersListAssembler.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import Foundation

final class OrdersListAssembler {
    static func assemble(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) -> OrderListView {
        let viewModel = OrdersListViewModel(networkManager: networkManager, imageProvider: imageProvider)
        return OrderListView(viewModel: viewModel)
    }
}
