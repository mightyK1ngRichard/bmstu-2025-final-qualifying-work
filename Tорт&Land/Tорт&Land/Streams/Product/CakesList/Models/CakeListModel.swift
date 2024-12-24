//
//  CakeListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

enum CakesListModel {}

extension CakesListModel {

    enum Section: Identifiable {
        case all([CakeModel])
        case sale([CakeModel])
        case new([CakeModel])
    }

    enum Screens: Hashable {
        case details(CakeModel)
    }
}

// MARK: - Section

extension CakesListModel.Section {

    var id: String {
        switch self {
        case .all:
            return "all"
        case .sale:
            return "sale"
        case .new:
            return "new"
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .new:
            return "New"
        case .sale:
            return "Sale"
        case .all:
            return "All"
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .new:
            return "You’ve never seen it before!"
        case .sale:
            return "Super summer sale"
        case .all:
            return "You can buy it right now!"
        }
    }
}
