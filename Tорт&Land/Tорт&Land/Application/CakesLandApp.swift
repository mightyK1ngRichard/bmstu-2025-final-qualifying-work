//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

@main
struct CakesLandApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            RootAssembler.assembleMock()
            #else
            RootAssembler.assemble()
            #endif
        }
    }
}
