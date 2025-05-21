//
//  OrderDetailViewModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation
import Observation

@Observable
final class OrderDetailViewModel {
    var bindingData = OrderDetailModel.BindingData()
    let order: OrderModel
    private(set) var cakeModel: CakeModel?
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProviderImpl

    init(order: OrderModel, networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) {
        self.order = order
        self.networkManager = networkManager
        self.imageProvider = imageProvider
    }
}

// MARK: - Network

extension OrderDetailViewModel {

    func fetchCakeByID() {
        Task { @MainActor in
            do {
                let res = try await networkManager.cakeService.fetchCakeByID(cakeID: order.cakeID)
                cakeModel = CakeModel(from: res.cake)
                fetchCakeImages(
                    previewImage: res.cake.imageURL,
                    images: res.cake.images.map { $0.imageURL },
                    userImage: res.cake.owner.imageURL)
            }
        }
    }

    func fetchCakeImages(previewImage: String, images: [String], userImage: String?) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: previewImage)
            cakeModel?.previewImage.imageState = imageState
        }

        for (index, imageURL) in images.enumerated() {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: imageURL)
                cakeModel?.thumbnails[index].imageState = imageState
            }
        }

        guard let userImage else { return }

        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: userImage)
            cakeModel?.seller.avatarImage.imageState = imageState
        }
    }

}
