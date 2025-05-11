//
//  CakeListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import NetworkAPI

enum CakesListModel {}

extension CakesListModel {
    struct BindingData: Hashable {
        var sections: [CakesListModel.Section] = [.sale([]), .new([]), .all([])]
        var screenState: ScreenState = .initial
    }

    enum Section: Identifiable, Hashable {
        case all([CakeModel])
        case sale([CakeModel])
        case new([CakeModel])

        enum Kind {
            case all, sale, new
        }
    }

    enum Screens: Hashable {
        case tags([CakeModel], ProductsGridModel.SectionKind)
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

    var cakes: [CakeModel] {
        switch self {
        case let .all(res), let .sale(res), let .new(res):
            return res
        }
    }

}

// MARK: - Section Kind

extension CakesListModel.Section.Kind {
    var arrayIndex: Int {
        switch self {
        case .sale:
            return 0
        case .new:
            return 1
        case .all:
            return 2
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
