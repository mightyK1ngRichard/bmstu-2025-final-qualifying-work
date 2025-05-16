//
//  Config.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Config<T> {
    let key: String
    let defaultValue: T
    let valueType: ValueType

    init(key: String, defaultValue: T, valueType: ValueType = .value) {
        self.key = key
        self.defaultValue = defaultValue
        self.valueType = valueType
    }

    public var wrappedValue: T {
        get {
            switch valueType {
            case .value:
                guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
                    Logger.log(kind: .warning, "\(key) not found in Info.plist, using default value: \(defaultValue)")
                    return defaultValue
                }
                return value
            case let .dict(dictName):
                guard let dictionary = Bundle.main.object(forInfoDictionaryKey: dictName) as? [String: Any],
                      let value = dictionary[key],
                      let castedValue = castValue(value)
                else {
                    Logger.log(kind: .warning, "\(key) not found in Info.plist, using default value: \(defaultValue)")
                    return defaultValue
                }

                return castedValue
            }
        }
    }

    private func castValue(_ value: Any) -> T? {
        if let typed = value as? T {
            return typed
        }

        // Попробуем привести строки к нужному типу
        if let string = value as? String {
            if T.self == Int.self, let intValue = Int(string) as? T {
                return intValue
            }
            if T.self == Double.self, let doubleValue = Double(string) as? T {
                return doubleValue
            }
            if T.self == Bool.self, let boolValue = Bool(string) as? T {
                return boolValue
            }
        }

        return nil
    }
}

extension Config {

    enum ValueType {
        case value
        case dict(dictName: String)
    }

}
