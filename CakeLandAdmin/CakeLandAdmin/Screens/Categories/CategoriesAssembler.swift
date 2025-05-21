//
//  CategoriesAssembler.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 13.05.2025.
//

final class CategoriesAssembler {
    static func assemble(
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProviderImpl,
        priceFormatter: PriceFormatterService = .shared
    ) -> CategoriesView {
        let viewModel = CategoriesViewModel(
            networkManager: networkManager,
            imageProvider: imageProvider,
            priceFormatter: priceFormatter
        )
        return CategoriesView(viewModel: viewModel)
    }
}
