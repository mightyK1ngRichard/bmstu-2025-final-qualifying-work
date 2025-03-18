//
//  CakesListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

@Observable
final class CakesListViewModel: CakesListDisplayData, CakesListViewModelInput {
    @ObservationIgnored
    var interactor: CakesListBusinessLogic!
    private(set) var bindingData = CakesListModel.BindingData()
    @ObservationIgnored
    private var coordinator: Coordinator!
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

        #if DEBUG
        MainActor.assertIsolated("Обновление не на главном потоке")
        #endif
    }

    func showError(message: String) {
        bindingData.screenState = .error

        #if DEBUG
        MainActor.assertIsolated("Обновление не на главном потоке")
        #endif
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

        #if DEBUG
        MainActor.assertIsolated("Обновление не на главном потоке")
        #endif
    }

}

// MARK: - Configuration

extension CakesListViewModel {

    func assemblyTagsView(
        cakes: [CakeModel],
        sectionKind: ProductsGridModel.SectionKind
    ) -> ProductsGridView {
//        let viewModel = ProductsGridViewModelMock(cakes: cakes, sectionKind: sectionKind)
//        return ProductsGridView(viewModel: viewModel)
        fatalError()
    }

    func configureShimmeringProductCard() -> TLProductCard.Configuration {
        .shimmering(imageHeight: 184)
    }

    func configureProductCard(model: CakeModel, section: CakesListModel.Section) -> TLProductCard.Configuration {
        return model.configureProductCard()
    }

}

// MARK: - Actions

extension CakesListViewModel {

    func didTapCell(model: CakeModel) {}

    func didTapNewsAllButton(_ cakes: [CakeModel]) {}

    func didTapSalesAllButton(_ cakes: [CakeModel]) {}

    func didTapLikeButton(model: CakeModel, isSelected: Bool) {}

}

// MARK: - Setter

extension CakesListViewModel {

    func setEnvironmentObjects(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }

}
