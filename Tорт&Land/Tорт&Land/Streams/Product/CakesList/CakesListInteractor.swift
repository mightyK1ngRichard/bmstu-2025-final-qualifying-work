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
    private let cakeService: CakeGrpcService
    private let imageProvider: ImageLoaderProvider

    init(cakeService: CakeGrpcService, imageProvider: ImageLoaderProvider) {
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
        if cake.discountKgPrice != nil {
            return .sale
        } else if cake.isNew {
            return .new
        }
        return .all
    }

    func fetchImages(for items: [(cake: PreviewCakeEntity, section: CakesListModel.Section.Kind, url: String)]) {
        for item in items {
            Task {
                do {
                    let imageState = try await imageProvider.fetchImage(for: item.url)
                    await presenter.updateCakeCellImage(cakeID: item.cake.id, imageState: imageState, with: item.section)
                } catch {
                    Logger.log(kind: .error, "Ошибка получения изображения: \(error.localizedDescription)")
                    await presenter.updateCakeCellImage(cakeID: item.cake.id, imageState: .error(.systemImage()), with: item.section)
                }
            }
        }
    }
}
