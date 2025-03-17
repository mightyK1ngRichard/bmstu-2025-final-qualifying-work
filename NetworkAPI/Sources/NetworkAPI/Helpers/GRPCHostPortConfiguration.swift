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
    case cake
}

public extension AppHosts {
    var hostName: String {
        switch self {
        case .auth, .cake:
        #if DEBUG
            return "localhost"
        #else
            return "localhost"
        #endif
        }
    }

    var port: Int {
        switch self {
        case .auth, .cake:
        #if DEBUG
            return 44044
        #else
            return 44044
        #endif
        }
    }
}
