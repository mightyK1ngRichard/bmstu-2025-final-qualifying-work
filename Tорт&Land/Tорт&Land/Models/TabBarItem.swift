//
//  TabBarItem.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum TabBarItem: String, CaseIterable {
    case house = "house"
    case categories = "cart"
    case chat = "message"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person"
}

extension TabBarItem {
    var title: LocalizedStringResource {
        switch self {
        case .house:
            return "Home"
        case .categories:
            return "Categories"
        case .chat:
            return "Chats"
        case .notifications:
            return "Notifications"
        case .profile:
            return "Profile"
        }
    }
}

// MARK: - AnimatedTab

struct AnimatedTab: Identifiable {
    let id = UUID()
    var tabBarItem: TabBarItem
    var isAnimating: Bool?
}
