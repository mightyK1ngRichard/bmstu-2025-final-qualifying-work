//
//  AppHosts.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Core

// MARK: - AppHosts

enum AppHosts: GRPCHostPortConfiguration {
    case auth
    case chat
    case cake
    case profile
    case reviews
    case order
    case notification
}

extension AppHosts {
    var hostName: String {
        switch self {
        case .auth, .cake, .profile, .chat, .reviews, .order, .notification:
            return AppConfig.networkIP
        }
    }

    var port: Int {
        switch self {
        case .cake:
            return AppConfig.ServicePorts.cake
        case .auth:
            return AppConfig.ServicePorts.auth
        case .profile:
            return AppConfig.ServicePorts.profile
        case .chat:
            return AppConfig.ServicePorts.chat
        case .reviews:
            return AppConfig.ServicePorts.reviews
        case .order:
            return AppConfig.ServicePorts.order
        case .notification:
            return AppConfig.ServicePorts.notification
        }
    }
}
