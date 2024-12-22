//
//  CakeDetailsViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

#if DEBUG

import Foundation

final class CakeDetailsViewModelMock: CakeDetailsDisplayLogic, CakeDetailsViewModelOutput {
    let currentUser = CakeDetailsModel.UserModel(id: "2", name: "Мария")
    var isOwnedByUser: Bool { cakeModel.seller.id == currentUser.id }
    private(set) var cakeModel = CakeDetailsModel.CakeModel.mockData
    private let worker = ProductCardWorker()

    func configureImageViewConfiguration(for imageState: ImageState) -> TLImageView.Configuration {
        .init(imageState: imageState)
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        .basic(
            title: cakeModel.cakeName,
            price: "$\(cakeModel.price)",
            discountedPrice: {
                guard let discountedPrice = cakeModel.discountedPrice else {
                    return nil
                }
                return "$\(discountedPrice)"
            }(),
            subtitle: cakeModel.seller.name,
            description: cakeModel.description,
            starsConfiguration: .basic(kind: .init(rawValue: cakeModel.fillStarsCount) ?? .zero, feedbackCount: cakeModel.numberRatings)
        )
    }

    func configureSimilarProductConfiguration(for model: CakeDetailsModel.CakeModel) -> TLProductCard.Configuration {
        let model = CakesListModel.CakeModel(
            id: model.id,
            imageState: model.images.first ?? .empty,
            sellerName: model.seller.name,
            cakeName: model.cakeName,
            price: model.price,
            discountedPrice: model.discountedPrice,
            fillStarsCount: model.fillStarsCount,
            numberRatings: model.numberRatings,
            isSelected: model.isFavorite
        )
        // FIXME: section: .all([]) поправить и придумать логику оценивания бейджа без хадкодинга
        return worker.configureProductCard(model: model, section: .all([]))
    }

    func didTapSellerInfoButton() {}

    func didTapRatingReviewsButton() {}

    func didTapBackButton() {}
}

// MARK: - CakeDetailsModel CakeModel

private extension CakeDetailsModel.CakeModel {
    static var mockData: CakeDetailsModel.CakeModel {
        var cake = generateCakeModel(id: 23)
        cake.similarCakes = (0...5).map { .generateCakeModel(id: $0) }
        return cake
    }

    static func generateCakeModel(id: Int) -> CakeDetailsModel.CakeModel {
        CakeDetailsModel.CakeModel(
            id: String(id),
            images: [
                .fetched(.uiImage(.cake1)),
                .fetched(.uiImage(.cake2)),
                .fetched(.uiImage(.cake3)),
            ].shuffled(),
            isFavorite: true,
            cakeName: "Моковый торт #\(id)",
            price: 19.99,
            discountedPrice: 15.99,
            description: """
            Состав:
            Бисквит (мука, яйцо, сахар)  Крем (творожный сыр, сливки 33%, сахарная пудра)  Мусс (творожный сыр, сливки 33%, сахар, печенье Орео, загуститель)  Белый шоколад, пищевой краситель
            Размер:
            Ширина - 12 см
            Высота - 8 см
            
            Вес товара:
            700 гр.
            Изготовитель:
            Ms cake
            """,
            fillStarsCount: id % 5,
            numberRatings: 10,
            similarCakes: [],
            seller: .init(
                id: "1",
                name: "Дмитрий Пермяков"
            )
        )
    }
}

#endif
