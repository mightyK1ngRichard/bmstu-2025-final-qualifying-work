//
//  CakesListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import DesignSystem
import Core

@Observable
final class CakesListViewModel: CakesListDisplayData, CakesListViewModelInput {
    private(set) var bindingData = CakesListModel.BindingData()
    private(set) var sections: [CakesListModel.SectionKind: [CakeModel]] = [:]
    @ObservationIgnored
    private var coordinator: Coordinator!
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider

    init(
        cakeService: CakeService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.priceFormatter = priceFormatter
        self.imageProvider = imageProvider
        self.cakeService = cakeService
    }
}

// MARK: - Network

extension CakesListViewModel {

    func fetchData() {
        bindingData.screenState = .loading
        Task { @MainActor in
            do {
                // Получаем преьюхи тортов
                let response = try await cakeService.fetchCakes()

                // Определяем категории тортов
                var tempSections: [CakesListModel.SectionKind: [CakeModel]] = [:]
                var images: [(section: CakesListModel.SectionKind, cakeID: String, url: String)] = []

                for cake in response.cakes {
                    let sectionKind = identifyСakeSection(for: cake)
                    tempSections[sectionKind, default: []].append(CakeModel(from: cake))
                    images.append((sectionKind, cake.id, cake.imageURL))
                }

                sections = tempSections
                bindingData.screenState = .finished

                // Тянем превью изображения тортов
                fetchImages(for: images)

            } catch {
                bindingData.screenState = .error(content: error.readableGRPCContent)
            }
        }
    }

    private func identifyСakeSection(for cake: PreviewCakeEntity) -> CakesListModel.SectionKind {
        if cake.discountKgPrice != nil, let discountEndTime = cake.discountEndTime, Date.now < discountEndTime {
            return .sale
        } else if cake.isNew {
            return .new
        }
        return .all
    }

    private func fetchImages(for items: [(section: CakesListModel.SectionKind, cakeID: String, url: String)]) {
        for item in items {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: item.url)
                if let index = sections[item.section]?.firstIndex(where: { item.cakeID == $0.id }) {
                    sections[item.section]?[safe: index]?.previewImageState = imageState
                }
            }
        }
    }

}

// MARK: - Configuration

extension CakesListViewModel {

    func assemblyTagsView(cakes: [CakeModel]) -> ProductsGridView {
        ProductsGridAssemler.assembly(cakes: cakes, cakeService: cakeService)
    }

    func configureShimmeringProductCard() -> TLProductCard.Configuration {
        .shimmering(imageHeight: 184)
    }

    func configureProductCard(model: CakeModel) -> TLProductCard.Configuration {
        model.configureProductCard(priceFormatter: priceFormatter)
    }

    func configureErrorView(content: AlertContent) -> TLErrorView.Configuration {
        .init(from: content)
    }

}

// MARK: - Actions

extension CakesListViewModel {
    
    /// Нажали на карточку товара
    func didTapCell(model: CakeModel) {
        coordinator.addScreen(RootModel.Screens.details(model))
    }

    /// Нажали кнопку `смотреть все`
    func didTapSectionAllButton(sectionKind: CakesListModel.SectionKind) {
        let sectionCakes = sections[sectionKind] ?? []
        coordinator.addScreen(CakesListModel.Screens.grid(sectionCakes))
    }
    
    /// Нажали на лайк карточки товара
    func didTapLikeButton(model: CakeModel, isSelected: Bool) {}

}

// MARK: - Setter

extension CakesListViewModel {

    func setEnvironmentObjects(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }

}
