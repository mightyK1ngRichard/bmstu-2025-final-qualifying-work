//
//  CakesListPresenter.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Core
import NetworkAPI
import GRPC
import NIO

final class CakesListPresenter: CakesListPresenterInput {
    weak var viewModel: CakesListDisplayLogic!

    func didFetchCakes(result: Result<[CakesListModel.Section.Kind: [PreviewCakeEntity]], Error>) async {
        do {
            let sections = try result.get()
            let resSections: [CakesListModel.Section] = [
                .sale(sections[.sale]?.map(CakeModel.init(from:)) ?? []),
                .new(sections[.new]?.map(CakeModel.init(from:)) ?? []),
                .all(sections[.all]?.map(CakeModel.init(from:)) ?? [])
            ]

            await viewModel.didFetchSections(with: resSections)
        } catch {
            await viewModel.showError(content: error.readableGRPCContent)
        }
    }

    func addCakesToRootViewModel(_ cakes: [CakeEntity]) async {
        await viewModel?.addCakesToRootViewModel(cakes)
    }

    func updateCakeCellImage(
        cakeID: String,
        imageState: ImageState,
        with sectionKind: CakesListModel.Section.Kind
    ) async {
        await viewModel.updateCakeCellImage(cakeID: cakeID, imageState: imageState, with: sectionKind)
    }

    @MainActor
    func updateUserAvatarImage(imageState: ImageState, cakeID: String) {
        viewModel.updateUserAvatarImage(imageState: imageState, cakeID: cakeID)
    }

    @MainActor
    func updateUserHeaderImage(imageState: ImageState, cakeID: String) {
        viewModel.updateUserHeaderImage(imageState: imageState, cakeID: cakeID)
    }
}
