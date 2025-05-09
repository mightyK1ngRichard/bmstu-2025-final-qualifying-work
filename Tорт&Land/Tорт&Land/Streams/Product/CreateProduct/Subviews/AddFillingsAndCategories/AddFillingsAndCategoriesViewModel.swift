//
//  AddFillingsAndCategoriesViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation
import NetworkAPI
import DesignSystem
import Core

@Observable
final class AddFillingsAndCategoriesViewModel {
    var fillings: [Filling] = []
    var categories: [Category] = []
    var selectedFillingsIDs: Set<String> = []
    var selectedCategoriesIDs: Set<String> = []

    @ObservationIgnored
    let cakeService: CakeService
    @ObservationIgnored
    let imageProvider: ImageLoaderProvider

    init(cakeService: CakeService, imageProvider: ImageLoaderProvider) {
        self.cakeService = cakeService
        self.imageProvider = imageProvider
    }
}

// MARK: - Actions & Configurations

extension AddFillingsAndCategoriesViewModel {

    func didTapFillingCard(with filling: Filling) {
        if selectedFillingsIDs.contains(filling.id) {
            selectedFillingsIDs.remove(filling.id)
        } else {
            selectedFillingsIDs.insert(filling.id)
        }
    }

    func didTapCategoryCard(with category: Category) {
        if selectedCategoriesIDs.contains(category.id) {
            selectedCategoriesIDs.remove(category.id)
        } else {
            selectedCategoriesIDs.insert(category.id)
        }
    }

    func showCategoryOverlay(for category: Category) -> Bool {
        selectedCategoriesIDs.contains(category.id)
    }

    func showFillingOverlay(for filling: Filling) -> Bool {
        selectedFillingsIDs.contains(filling.id)
    }

    func configureImageView(imageState: ImageState) -> TLImageView.Configuration {
        .init(imageState: imageState)
    }

    func getSelectedFillings() -> [Filling] {
        fillings.filter { filling in
            selectedFillingsIDs.contains(where: { $0 == filling.id })
        }
    }

    func getSelectedCategories() -> [Category] {
        categories.filter { category in
            selectedCategoriesIDs.contains(where: { $0 == category.id })
        }
    }

}

// MARK: - Network

extension AddFillingsAndCategoriesViewModel {

    func fetchFittings() {
        Task { @MainActor in
            do {
                let response = try await cakeService.fetchFillings()
                fillings = response.fillings.enumerated().map { (index, entity) in
                    fetchFillingsImages(index: index, imageString: entity.imageURL)
                    return Filling(from: entity)
                }
            } catch {

            }
        }
    }

    func fetchCategories() {
        Task { @MainActor in
            do {
                let response = try await cakeService.fetchCategories()
                categories = response.categories.enumerated().map { (index, entity) in
                    fetchCategoriesImages(index: index, imageString: entity.imageURL)
                    return Category.init(from: entity)
                }
            } catch {

            }
        }
    }

}

private extension AddFillingsAndCategoriesViewModel {

    func fetchFillingsImages(index: Int, imageString: String?) {
        Task { @MainActor in
            guard let imageString else {
                fillings[safe: index]?.imageState = .error(.systemImage())
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageString)
            fillings[safe: index]?.imageState = imageState
        }
    }

    func fetchCategoriesImages(index: Int, imageString: String?) {
        Task { @MainActor in
            guard let imageString else {
                categories[safe: index]?.imageState = .error(.systemImage())
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageString)
            categories[safe: index]?.imageState = imageState
        }
    }

}
