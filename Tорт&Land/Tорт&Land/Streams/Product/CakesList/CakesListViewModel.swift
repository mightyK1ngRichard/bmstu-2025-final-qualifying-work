//
//  CakesListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

@Observable
final class CakesListViewModel: CakesListDisplayData, CakesListViewModelInput {
    @ObservationIgnored
    var interactor: CakesListBusinessLogic!
    private(set) var bindingData = CakesListModel.BindingData()
    @ObservationIgnored
    private var coordinator: Coordinator!
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private var rootViewModel: RootViewModelOutput

    init(
        rootViewModel: RootViewModelOutput,
        cakeService: CakeService,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.priceFormatter = priceFormatter
        self.rootViewModel = rootViewModel
        self.cakeService = cakeService
    }
}

// MARK: - Network

extension CakesListViewModel {

    func fetchData() {
        bindingData.screenState = .loading
        interactor.fetchCakes()
    }

}

// MARK: - Presenter

extension CakesListViewModel: CakesListDisplayLogic {

    func didFetchSections(with sections: [CakesListModel.Section]) {
        bindingData.sections = sections
        bindingData.screenState = .finished
    }

    func showError(message: String) {
        bindingData.screenState = .error(message: message)
    }

    func updateUserAvatarImage(imageState: ImageState, cakeID: String) {
        for (i, section) in bindingData.sections.enumerated() {
            guard let index = section.cakes.firstIndex(where: { $0.id == cakeID }) else {
                continue
            }

            switch section {
            case let .all(cakes):
                var updatedCake = cakes
                updatedCake[index].seller.avatarImage = imageState
                bindingData.sections[i] = .all(updatedCake)
            case let .sale(cakes):
                var updatedCake = cakes
                updatedCake[index].seller.avatarImage = imageState
                bindingData.sections[i] = .sale(updatedCake)
            case let .new(cakes):
                var updatedCake = cakes
                updatedCake[index].seller.avatarImage = imageState
                bindingData.sections[i] = .new(updatedCake)
            }
        }
    }

    func updateUserHeaderImage(imageState: ImageState, cakeID: String) {
//        viewModel.updateUserHeaderImage(imageState: imageState)
    }

    func addCakesToRootViewModel(_ cakes: [CakeEntity]) {
        rootViewModel.setCakes(cakes)
    }

    func updateCakeCellImage(
        cakeID: String,
        imageState: ImageState,
        with sectionKind: CakesListModel.Section.Kind
    ) {
        let arrayIndex = sectionKind.arrayIndex
        var cakes = bindingData.sections[arrayIndex].cakes
        guard let index = cakes.firstIndex(where: { $0.id == cakeID }) else {
            return
        }

        cakes[index].previewImageState = imageState
        switch sectionKind {
        case .all:
            bindingData.sections[arrayIndex] = .all(cakes)
        case .sale:
            bindingData.sections[arrayIndex] = .sale(cakes)
        case .new:
            bindingData.sections[arrayIndex] = .new(cakes)
        }
    }

}

// MARK: - Configuration

extension CakesListViewModel {

    func assemblyTagsView(
        cakes: [CakeModel],
        sectionKind: ProductsGridModel.SectionKind
    ) -> ProductsGridView {
        ProductsGridAssemler.assembly(cakes: cakes, sectionKind: sectionKind, cakeService: cakeService)
    }

    func configureShimmeringProductCard() -> TLProductCard.Configuration {
        .shimmering(imageHeight: 184)
    }

    func configureProductCard(model: CakeModel, section: CakesListModel.Section.Kind) -> TLProductCard.Configuration {
        model.configureProductCard(priceFormatter: priceFormatter)
    }

    func configureErrorView(message: String) -> TLErrorView.Configuration {
        .init(kind: .customError("Network Error", message))
    }

}

// MARK: - Actions

extension CakesListViewModel {
    
    /// Нажали на карточку товара
    func didTapCell(model: CakeModel) {
        coordinator.addScreen(RootModel.Screens.details(model))
    }

    /// Нажали кнопку `смотреть все`
    func didTapAllButton(_ cakes: [CakeModel], section: ProductsGridModel.SectionKind) {
        coordinator.addScreen(CakesListModel.Screens.tags(cakes, section))
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
