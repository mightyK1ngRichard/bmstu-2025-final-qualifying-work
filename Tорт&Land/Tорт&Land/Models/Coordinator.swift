//
//  Coordinator.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//

import Foundation
import SwiftUI

@Observable
final class Coordinator {
    var navPath = NavigationPath()
}

extension Coordinator {

    func addScreen<T: Hashable>(_ screen: T) {
        navPath.append(screen)
    }

    func openPreviousScreen() {
        guard navPath.count - 1 >= 0 else { return }
        navPath.removeLast()
    }

    func goToRoot() {
        while navPath.count > 0 {
            navPath.removeLast()
        }
    }
}
