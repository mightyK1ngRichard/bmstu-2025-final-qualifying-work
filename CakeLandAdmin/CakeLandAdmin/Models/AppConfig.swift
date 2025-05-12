//
//  AppConfig.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

// MARK: - AppConfig

public enum AppConfig {
    @Config(key: "NETWORK_IP", defaultValue: "localhost")
    public static var networkIP: String

    public enum ServicePorts {
        @Config(key: "cake", defaultValue: 44044, valueType: .dict(dictName: "Ports"))
        public static var cake: Int

        @Config(key: "auth", defaultValue: 44045, valueType: .dict(dictName: "Ports"))
        public static var auth: Int

        @Config(key: "profile", defaultValue: 44046, valueType: .dict(dictName: "Ports"))
        public static var profile: Int

        @Config(key: "chat", defaultValue: 44047, valueType: .dict(dictName: "Ports"))
        public static var chat: Int

        @Config(key: "reviews", defaultValue: 44048, valueType: .dict(dictName: "Ports"))
        public static var reviews: Int

        @Config(key: "order", defaultValue: 44049, valueType: .dict(dictName: "Ports"))
        public static var order: Int

        @Config(key: "notification", defaultValue: 44050, valueType: .dict(dictName: "Ports"))
        public static var notification: Int
    }
}
