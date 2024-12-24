//
//  CakesListViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class CakesListViewModelMock: CakesListDisplayLogic, CakesListViewModelOutput {
    private(set) var sections: [CakesListModel.Section] = []
    private(set) var screenState: ScreenState = .initial
    @ObservationIgnored
    private var delay: TimeInterval = 0
    @ObservationIgnored
    private let productWorker = ProductCardWorker()
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func fetchData() {
        screenState = .loading
        Task {
            try? await Task.sleep(for: .seconds(delay))
            await MainActor.run {
                sections = [
                    .sale(
                        (1...20).map { CommonMockData.generateMockCakeModel(id: $0) }
                    ),
                    .new(
                        (21...32).map { CommonMockData.generateMockCakeModel(id: $0) }
                    ),
                    .all(
                        (33...40).map { CommonMockData.generateMockCakeModel(id: $0) }
                    )
                ]
                screenState = .finished
            }
        }
    }

    func didTapNewsAllButton(_ configurations: [CakeModel]) {
        print("[DEBUG]: Нажали секцию news")
    }

    func didTapSalesAllButton(_ configurations: [CakeModel]) {
        print("[DEBUG]: Нажали секцию sales")
    }

    func didTapCell(model: CakeModel) {
        print("[DEBUG]: Нажали на торт: \(model.id)")
        coordinator?.addScreen(CakesListModel.Screens.details(model))
    }

    func didTapLikeButton(model: CakeModel, isSelected: Bool) {
        print("[DEBUG]: Нажали лайк для торта: \(model.id), isSelected: \(isSelected)")
    }
}

// MARK: - Configuration

extension CakesListViewModelMock {

    func assemblyDetailsView(model: CakeModel) -> CakeDetailsView {
        let viewModel = CakeDetailsViewModelMock(cakeModel: model)
        return CakeDetailsView(viewModel: viewModel)
    }

    func configureShimmeringProductCard() -> TLProductCard.Configuration {
        .shimmering(imageHeight: 184)
    }

    func configureProductCard(model: CakeModel, section: CakesListModel.Section) -> TLProductCard.Configuration {
        productWorker.configureProductCard(model: model, section: section)
    }
}

// MARK: - Setter

extension CakesListViewModelMock {

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

#endif
