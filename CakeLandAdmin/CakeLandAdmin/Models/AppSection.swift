//
//  AppSection.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

enum AppSection: String, Hashable, CaseIterable {
    case home = "Главная"
    case profile = "Профиль"
    case orders = "Заказы"
    case settings = "Настройки"


    var iconName: String {
        switch self {
        case .home: return "house"
        case .profile: return "person.circle"
        case .settings: return "gearshape"
        case .orders: return "shippingbox"
        }
    }
}
