//
//  CakeDetailsViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

#if DEBUG

import Foundation
import DesignSystem

@Observable
final class CakeDetailsViewModelMock: CakeDetailsDisplayData & CakeDetailsViewModelInput {
    var bindingData: CakeDetailsModel.BindingData
    private(set) var showOwnerButton: Bool
    private(set) var show3DButton = true
    private(set) var cakeModel: CakeModel
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let priceFormatter = PriceFormatterService.shared

    init(
        bindingData: CakeDetailsModel.BindingData = .init(),
        isOwnedByUser: Bool,
        cakeModel: CakeModel = CommonMockData.generateMockCakeModel(id: 23)
    ) {
        self.bindingData = bindingData
        self.showOwnerButton = !isOwnedByUser
        self.cakeModel = cakeModel
    }

    func fetchCakeDetails() {
        cakeModel.similarCakes = (1...10).map { CommonMockData.generateMockCakeModel(id: $0) }
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func didTapMakeOrderButton() {
        print("[DEBUG]: \(#function)")
    }

    func didTapSellerInfoButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.addScreen(RootModel.Screens.profile(cakeModel.seller))
    }

    func didTapRatingReviewsButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.addScreen(CakeDetailsModel.Screens.ratingReviews)
    }

    func didTapBackButton() {
        print("[DEBUG]: \(#function)")
        coordinator?.openPreviousScreen()
    }

    func didTapSimilarCake(model: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(model))
    }

    func didTapCakeLike(model: CakeModel, isSelected: Bool) {}

    func fetchCakeDetails(cakeUID: String) {}

    func didTapFilling(with filling: Filling) {
        bindingData.selectedFilling = filling
        bindingData.showSheet = true
    }

    func didTap3DButton() {}
    
    func didTapAdd3DModel() {}

    func didSelectFile(url: URL) {}
}

// MARK: - Configure

extension CakeDetailsViewModelMock {
    func assemblyRatingReviewsView() -> RatingReviewsView {
        let viewModel = RatingReviewsViewModelMock(comments: cakeModel.comments)
        return RatingReviewsView(viewModel: viewModel)
    }

    func configurePreviewImageViewConfiguration() -> TLImageView.Configuration {
        .init(imageState: cakeModel.previewImageState)
    }

    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration {
        .init(imageState: thumbnail.imageState)
    }

    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration {
        cakeModel.configureDescriptionView(priceFormatter: priceFormatter)
    }

    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration {
        model.configureProductCard(priceFormatter: priceFormatter)
    }

    func configureFillingDetails(for filling: Filling) -> FillingDetailView.Configuration {
        .init(
            name: filling.name,
            imageState: filling.imageState,
            content: filling.content,
            kgPrice: priceFormatter.formatKgPrice(filling.kgPrice),
            description: filling.description
        )
    }
}

#endif
