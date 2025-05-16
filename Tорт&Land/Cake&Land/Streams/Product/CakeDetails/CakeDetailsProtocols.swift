//
//  CakeDetailsProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation
import DesignSystem

protocol CakeDetailsDisplayData {
    var bindingData: CakeDetailsModel.BindingData { get set }
    var cakeModel: CakeModel { get }
}

protocol CakeDetailsViewModelInput {
    func fetchCakeDetails()

    func setEnvironmentObjects(coordinator: Coordinator)
    func configureImageViewConfiguration(for thumbnail: Thumbnail) -> TLImageView.Configuration
    func configurePreviewImageViewConfiguration() -> TLImageView.Configuration
    func configureSimilarProductConfiguration(for model: CakeModel) -> TLProductCard.Configuration
    func configureProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration
    func configureFillingDetails(for filling: Filling) -> FillingDetailView.Configuration
    func assemblyRatingReviewsView() -> RatingReviewsView

    func didTapMakeOrderButton()
    func didTapUpdateVisable()
    func didTapSellerInfoButton()
    func didTapRatingReviewsButton()
    func didTapBackButton()
    func didTapSimilarCake(model: CakeModel)
    func didTapCakeLike(model: CakeModel, isSelected: Bool)
    func didTapFilling(with filling: Filling)
    func didTapAdd3DModel()
    func didTap3DButton()
    func visableButtonConfiguration() -> TLButton.Configuration
    func didSelectFile(url: URL)
}

protocol CakeDetailsViewModelOutput {
}
