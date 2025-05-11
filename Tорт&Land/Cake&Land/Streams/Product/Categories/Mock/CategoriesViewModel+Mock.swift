//
//  CategoriesViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation
import UIKit
import NetworkAPI
import Core
import SwiftUI

@Observable
final class CategoriesViewModelMock: CategoriesDisplayLogic, @preconcurrency CategoriesViewModelOutput {
    var uiProperties = CategoriesModel.UIProperties()
    private(set) var tabs: [CategoriesModel.Tab] = CategoriesModel.Tab.allCases
    private(set) var sections: [CategoriesModel.Tab: [CategoryCardModel]] = [
        .women: MockData.womenCards,
        .men: MockData.menCards,
        .kids: MockData.kidsCards,
    ]

    func setEnvironmentObjects(coordinator: Coordinator) {}

    func didTapSearchToggle() {
        withAnimation {
            uiProperties.showSearchBar.toggle()
        }
    }

    func didTapTab(tab: CategoriesModel.Tab) {
        withAnimation(.snappy) {
            uiProperties.selectedTab = tab
        }
    }

    func didTapSectionCell(section: CategoryCardModel) {
        print("[DEBUG]: \(section)")
    }

    func filterData(categories: [CategoryCardModel]) -> [CategoryCardModel] {
        uiProperties.searchText.isEmpty
            ? categories
            : categories.filter {
                $0.title.lowercased().contains(uiProperties.searchText.lowercased())
            }
    }

    func didUpdateSelectedTag(section: CategoriesModel.Tab) {
        print("[DEBUG]: \(section)")
    }

    func onAppear() {
        Task { @MainActor in
            try await Task.sleep(for: .seconds(2))
            uiProperties.state = .finished
        }
    }

    @MainActor
    func assemlyCakesCategoryView(cakes: [CakeModel]) -> ProductsGridView {
        fatalError("not implemented")
    }
}

// MARK: - MockData

private extension CategoriesViewModelMock {
    enum MockData {
        static let womenCards = (1...10).map {
            generateCategoryCardModel(title: "Woman cakes", id: $0)
        }
        static let menCards = (1...10).map {
            generateCategoryCardModel(title: "Man cakes", id: $0)
        }
        static let kidsCards = (1...10).map {
            generateCategoryCardModel(title: "Kid cakes", id: $0)
        }

        private static func generateCategoryCardModel(title: String, id: Int) -> CategoryCardModel {
            CategoryCardModel(
                id: String(id),
                title: "\(title) #\(id)",
                imageState: .fetched(
                    .uiImage(
                        [TLPreviewAssets.cake1, TLPreviewAssets.cake2, TLPreviewAssets.cake3].randomElement() ?? TLPreviewAssets.cake1
                    )
                )
            )
        }
    }
}

#endif
