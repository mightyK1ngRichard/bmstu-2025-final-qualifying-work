//
//  OrderDetailsViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 10.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import NetworkAPI
import DesignSystem
import UIKit

@Observable
final class OrderDetailsViewModel {
    private(set) var orderEntity: OrderEntity
    private(set) var cakeModel: CakeModel?
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService

    init(
        orderEntity: OrderEntity,
        cakeService: CakeService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.orderEntity = orderEntity
        self.cakeService = cakeService
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
    }
}

// MARK: - Network

extension OrderDetailsViewModel {

    func fetchCakeData() {
        Task { @MainActor in
            do {
                let res = try await cakeService.fetchCakeByID(cakeID: orderEntity.cakeID)
                cakeModel = CakeModel(from: res.cake)
                fetchCakeImages(previewImage: res.cake.imageURL, images: res.cake.images)
            }
        }
    }

    private func fetchCakeImages(previewImage: String, images: [CakeEntity.CakeImageEntity]) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: previewImage)
            cakeModel?.previewImageState = imageState
        }

        for (index, image) in images.enumerated() {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: image.imageURL)
                cakeModel?.thumbnails[index].imageState = imageState
            }
        }
    }

}

// MARK: - Configuration

extension OrderDetailsViewModel {

    func configureCakeCard(cakeModel: CakeModel) -> TLProductDescriptionView.Configuration {
        cakeModel.configureDescriptionView(priceFormatter: priceFormatter)
    }

}

// MARK: - Action

extension OrderDetailsViewModel {

    func copyOrderID() {
        UIPasteboard.general.string = orderEntity.id
    }

}
