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
        orderProvider: OrderService,
        profileProvider: ProfileService,
        cakeProvider: CakeService,
        imageProvider: ImageLoaderProvider
    ) -> OrderView {
        let viewModel = OrderViewModel(
            cakeID: cakeID,
            orderProvider: orderProvider,
            profileProvider: profileProvider,
            cakeProvider: cakeProvider,
            imageProvider: imageProvider
        )
        return OrderView(viewModel: viewModel)
    }
}
