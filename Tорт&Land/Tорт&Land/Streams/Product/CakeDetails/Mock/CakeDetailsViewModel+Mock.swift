//
//  CakeDetailsViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

#if DEBUG

import Foundation

final class CakeDetailsViewModelMock: CakeDetailsDisplayLogic, CakeDetailsViewModelOutput {
    let currentUser = UserModel(id: "1", name: "Дмитрий Пермяков")
    var isOwnedByUser: Bool { cakeModel.seller.id == currentUser.id }
    private(set) var cakeModel: CakeModel
    @ObservationIgnored
    private let worker = ProductCardWorker()
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(cakeModel: CakeModel = CommonMockData.generateMockCakeModel(id: 23)) {
        self.cakeModel = cakeModel
    }

    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration {
        .init(imageState: thumbnail.imageState)
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

    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration {
        // FIXME: section: .all([]) поправить и придумать логику оценивания бейджа без хадкодинга
        return worker.configureProductCard(model: model, section: .all([]))
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func didTapSellerInfoButton() {}

    func didTapRatingReviewsButton() {}

    func didTapBackButton() {}

    func didTapSimilarCake(model: CakeModel) {
        coordinator?.addScreen(CakesListModel.Screens.details(model))
    }

    func didTapCakeLike(model: CakeModel, isSelected: Bool) {}
}

#endif
