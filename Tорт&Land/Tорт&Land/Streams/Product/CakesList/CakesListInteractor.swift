//
//  CakesListInteractor.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class CakesListInteractor: CakesListBusinessLogic {
    var presenter: CakesListPresenterInput!
    private let cakeService: CakeService
    private let imageProvider: ImageLoaderProvider

    init(cakeService: CakeService, imageProvider: ImageLoaderProvider) {
        self.cakeService = cakeService
        self.imageProvider = imageProvider
    }
}

extension CakesListInteractor {
    /// Получаем данные по тортам
    func fetchCakes() {
        Task {
            do {
                let response = try await cakeService.fetchCakes()
                let cakes = response.cakes

                // Определяем категории тортов
                var sections: [CakesListModel.Section.Kind: [PreviewCakeEntity]] = [:]
                var images: [(cake: PreviewCakeEntity, section: CakesListModel.Section.Kind, url: String)] = []

                var cakeEntities: [CakeEntity] = []
                cakeEntities.reserveCapacity(cakes.count)
                for cake in cakes {
                    cakeEntities.append(CakeEntity(from: cake))
                    let section = identifyСakeSection(for: cake)
                    sections[section, default: []].append(cake)
                    images.append((cake, section, cake.imageURL))
                    fetchUserImages(user: cake.owner, cakeID: cake.id)
                }

                await presenter.didFetchCakes(result: .success(sections))
                fetchImages(for: images)

                await presenter.addCakesToRootViewModel(cakeEntities)
            } catch {
                await presenter.didFetchCakes(result: .failure(error))
            }
        }
    }
}

// MARK: - Helpers

private extension CakesListInteractor {

    func identifyСakeSection(for cake: PreviewCakeEntity) -> CakesListModel.Section.Kind {
        if cake.discountKgPrice != nil, let discountEndTime = cake.discountEndTime, Date.now < discountEndTime {
            return .sale
        } else if cake.isNew {
            return .new
        }
        return .all
    }

    func fetchUserImages(user: UserEntity, cakeID: String) {
        Task { @MainActor in
            guard let imageURL = user.imageURL else {
                presenter.updateUserAvatarImage(imageState: .fetched(.uiImage(.profile)), cakeID: cakeID)
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageURL)
            presenter.updateUserAvatarImage(imageState: imageState, cakeID: cakeID)
        }

        Task { @MainActor in
            guard let imageURL = user.headerImageURL else {
                presenter.updateUserHeaderImage(imageState: .empty, cakeID: cakeID)
                return
            }

            let imageState = await imageProvider.fetchImage(for: imageURL)
            presenter.updateUserHeaderImage(imageState: imageState, cakeID: cakeID)
        }
    }

    func fetchImages(for items: [(cake: PreviewCakeEntity, section: CakesListModel.Section.Kind, url: String)]) {
        for item in items {
            Task {
                let imageState = await imageProvider.fetchImage(for: item.url)
                await presenter.updateCakeCellImage(cakeID: item.cake.id, imageState: imageState, with: item.section)
            }
        }
    }
}
