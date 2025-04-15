//
//  GRPCHostPortConfiguration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

// MARK: - GRPCHostPortConfiguration

public protocol GRPCHostPortConfiguration: Sendable {
    var hostName: String { get }
    var port: Int { get }
}

// MARK: - AppHosts

public enum AppHosts: GRPCHostPortConfiguration {
    case auth
    case chat
    case cake
    case profile
}

public extension AppHosts {
    var hostName: String {
        switch self {
        case .auth, .cake, .profile, .chat:
        #if DEBUG
            return "localhost"
        #else
            return "localhost"
        #endif
        }
    }

    var port: Int {
        switch self {
        #if DEBUG
        case .cake:
            return 44044
        case .auth:
            return 44045
        case .profile:
            return 44046
        case .chat:
            return 44047
        #else
        case .cake:
            return 44044
        case .auth:
            return 44045
        case .profile:
            return 44046
        case .chat:
            return 44047
        #endif
        }
    }
}
