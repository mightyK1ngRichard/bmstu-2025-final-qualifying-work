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
    private var delay: TimeInterval = 0
    private let productWorker = ProductCardWorker()

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
                        (1...20).map { generateCakeModel(id: $0) }
                    ),
                    .new(
                        (21...32).map { generateCakeModel(id: $0) }
                    ),
                    .all(
                        (33...40).map { generateCakeModel(id: $0) }
                    )
                ]
                screenState = .finished
            }
        }
    }

    func didTapNewsAllButton(_ configurations: [CakesListModel.CakeModel]) {
        print("[DEBUG]: Нажали секцию news")
    }

    func didTapSalesAllButton(_ configurations: [CakesListModel.CakeModel]) {
        print("[DEBUG]: Нажали секцию sales")
    }

    func didTapCell(model: CakesListModel.CakeModel) {
        print("[DEBUG]: Нажали на торт: \(model.id)")
    }

    func didTapLikeButton(model: CakesListModel.CakeModel, isSelected: Bool) {
        print("[DEBUG]: Нажали лайк для торта: \(model.id), isSelected: \(isSelected)")
    }
}

// MARK: - Configuration

extension CakesListViewModelMock {

    func configureShimmeringProductCard() -> TLProductCard.Configuration {
        .shimmering(imageHeight: 184)
    }

    func configureProductCard(model: CakesListModel.CakeModel, section: CakesListModel.Section) -> TLProductCard.Configuration {
        productWorker.configureProductCard(model: model, section: section)
    }
}

// MARK: - Helpers

private extension CakesListViewModelMock {

    func generateCakeModel(id: Int) -> CakesListModel.CakeModel {
        .init(
            id: String(id),
            imageState: .fetched(.uiImage([.cake1, .cake2, .cake3].randomElement() ?? .cake1)),
            sellerName: "Пермяков Дмитрий #\(id)",
            cakeName: "Название торта #\(id)",
            price: Double("1\(id)") ?? 0,
            discountedPrice: Double(id),
            fillStarsCount: id % 5,
            numberRatings: id,
            isSelected: id % 2 == 0
        )
    }
}

#endif
