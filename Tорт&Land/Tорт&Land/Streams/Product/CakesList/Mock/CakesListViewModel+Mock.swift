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
        let badgeViewConfiguration: TLBadgeView.Configuration? = {
            let text: String
            let kind: TLBadgeView.Configuration.Kind
            switch section {
            case .new:
                text = "NEW"
                kind = .dark
            case .sale:
                guard let discountedPrice = model.discountedPrice else {
                    return nil
                }
                let discountPercentage = (discountedPrice * 100) / model.price
                text = "-\(Int(round(discountPercentage)))%"
                kind = .red
            case .all:
                return nil
            }

            return .basic(text: text, kind: kind)
        }()
        let productDiscountedPrice: String? = {
            guard let discountedPrice = model.discountedPrice else {
                return nil
            }
            return "\(discountedPrice)$"
        }()

        return .basic(
            imageState: model.imageState,
            imageHeight: 184,
            productText: .init(
                seller: model.sellerName,
                productName: model.cakeName,
                productPrice: "\(model.price)$",
                productDiscountedPrice: productDiscountedPrice
            ),
            badgeViewConfiguration: badgeViewConfiguration,
            productButtonConfiguration: .basic(kind: .favorite(isSelected: model.isSelected))
        )
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
