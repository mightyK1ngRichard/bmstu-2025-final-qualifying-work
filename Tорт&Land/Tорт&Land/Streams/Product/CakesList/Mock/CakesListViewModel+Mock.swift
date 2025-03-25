//
//  CakesListViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class CakesListViewModelMock: CakesListViewModelInput, CakesListDisplayLogic, CakesListDisplayData {
    var bindingData = CakesListModel.BindingData()
    @ObservationIgnored
    private var delay: TimeInterval = 0
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let priceFormatter = PriceFormatterService.shared

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func fetchData() {
        bindingData.screenState = .loading
        Task {
            try? await Task.sleep(for: .seconds(delay))
            await MainActor.run {
                bindingData.sections = [
                    .sale(MockData.saleCakes),
                    .new(MockData.newCakes),
                    .all(MockData.allCakes)
                ]
                bindingData.screenState = .finished
            }
        }
    }

    func didFetchSections(with sections: [CakesListModel.Section]) {
    }

    func showError(message: String) {
    }

    func updateCakeCellImage(cakeID: String, imageState: ImageState, with sectionKind: CakesListModel.Section.Kind) {
    }

    func didTapAllButton(_ cakes: [CakeModel], section: ProductsGridModel.SectionKind) {
        print("[DEBUG]: Нажали кнопку смотреть все")
        coordinator?.addScreen(CakesListModel.Screens.tags(cakes, section))
    }

    func didTapCell(model: CakeModel) {
        print("[DEBUG]: Нажали на торт: \(model.id)")
        coordinator?.addScreen(RootModel.Screens.details(model))
    }

    func didTapLikeButton(model: CakeModel, isSelected: Bool) {
        print("[DEBUG]: Нажали лайк для торта: \(model.id), isSelected: \(isSelected)")
    }
}

// MARK: - Configuration

extension CakesListViewModelMock {
    func assemblyTagsView(cakes: [CakeModel], sectionKind: ProductsGridModel.SectionKind) -> ProductsGridView {
        let viewModel = ProductsGridViewModelMock(cakes: cakes, sectionKind: sectionKind)
        return ProductsGridView(viewModel: viewModel)
    }

    func configureShimmeringProductCard() -> TLProductCard.Configuration {
        .shimmering(imageHeight: 184)
    }

    func configureProductCard(model: CakeModel, section: CakesListModel.Section.Kind) -> TLProductCard.Configuration {
        model.configureProductCard(priceFormatter: priceFormatter)
    }
}

// MARK: - Setter

extension CakesListViewModelMock {
    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Constants

private extension CakesListViewModelMock {
    enum MockData {
        static let saleCakes = (1...20).map {
            var cakes = CommonMockData.generateMockCakeModel(id: $0)
            cakes.similarCakes = newCakes
            return cakes
        }
        static let newCakes = (21...32).map {
            var cakes = CommonMockData.generateMockCakeModel(id: $0, withDiscount: false)
            cakes.similarCakes = allCakes
            return cakes
        }
        static let allCakes = (33...40).map {
            var cakes = CommonMockData.generateMockCakeModel(id: $0, withDiscount: false)
            return cakes
        }
    }
}
#endif
