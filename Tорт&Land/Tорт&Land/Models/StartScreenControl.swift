//
//  StartScreenControl.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation

@Observable
final class StartScreenControl {
    private(set) var screenKind: StartScreenKind

    init() {
        guard
            let stringKind = UserDefaults.standard.string(forKey: UserDefaultsKeys.startScreenKind.rawValue),
            let kind = StartScreenKind(rawValue: stringKind)
        else {
            screenKind = .initial
            return
        }
        screenKind = kind
    }

    func update(with newScreenKind: StartScreenKind) {
        screenKind = newScreenKind
        UserDefaults.standard.set(newScreenKind.rawValue, forKey: UserDefaultsKeys.startScreenKind.rawValue)
    }
}
