//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI

@main
struct CakesLandApp: App {
    @State private var startScreenControl = StartScreenControl()

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            UserLocationView(viewModel: UserLocationViewModel())
//            RootAssembler.assembleMock()
//            RootAssembler.assemble(startScreenControl: startScreenControl)
//                .environment(startScreenControl)
            #else
            RootAssembler.assemble(startScreenControl: startScreenControl)
                .environment(startScreenControl)
            #endif
        }
    }
}
