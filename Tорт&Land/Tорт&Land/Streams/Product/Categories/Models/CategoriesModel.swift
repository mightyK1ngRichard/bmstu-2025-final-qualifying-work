//
//  CategoriesModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum CategoriesModel {}

extension CategoriesModel {
    struct UIProperties {
        var tabBarProgess: CGFloat = .zero
        var selectedTab: Tab? = .women
        var searchText = ""
        var showSearchBar = false
    }

    enum Tab: String, CaseIterable {
        case women
        case men
        case kids
    }

    enum Section: Identifiable {
        case men([CategoryCardModel])
        case women([CategoryCardModel])
        case kids([CategoryCardModel])
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
