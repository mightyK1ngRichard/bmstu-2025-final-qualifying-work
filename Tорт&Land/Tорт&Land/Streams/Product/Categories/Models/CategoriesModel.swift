//
//  CategoriesModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

enum CategoriesModel {}

extension CategoriesModel {
    struct UIProperties: Hashable {
        var tabBarProgess: CGFloat = .zero
        var selectedTab: Tab? = .women
        var searchText = ""
        var errorMessage: String?
        var showSearchBar = false
        var showLoading = false
    }

    enum Tab: String, Hashable, CaseIterable {
        case women
        case men
        case kids
    }

    enum Section: Identifiable {
        case men([CategoryCardModel])
        case women([CategoryCardModel])
        case kids([CategoryCardModel])
    }

    enum Screens: Hashable {
        case cakes([CakeModel])
    }
}

// MARK: - Tabs

extension CategoriesModel.Tab {
    var title: LocalizedStringResource {
        switch self {
        case .men:
            return "men"
        case .women:
            return "women"
        case .kids:
            return "kids"
        }
    }

    func convertToCategoryGender() -> CategoryGender {
        switch self {
        case .women:
            return .female
        case .men:
            return .male
        case .kids:
            return .child
        }
    }
}

// MARK: - Section

extension CategoriesModel.Section {
    var id: String {
        switch self {
        case .men:
            return "men"
        case .women:
            return "women"
        case .kids:
            return "kids"
        }
    }
}
