//
//  OrderAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class OrderAssembler {
    static func assemble(
        cakeID: String,
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProvider
    ) -> OrderView {
        let viewModel = OrderViewModel(
            cakeID: cakeID,
            networkManager: networkManager,
            imageProvider: imageProvider
        )
        return OrderView(viewModel: viewModel)
    }
}
