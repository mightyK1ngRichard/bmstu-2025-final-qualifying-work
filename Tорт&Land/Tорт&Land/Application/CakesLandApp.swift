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
            RootAssembler.assemble(startScreenControl: startScreenControl)
                .environment(startScreenControl)
//            RemoteARQuickLookView(remoteURL: URL(string: "http://192.168.1.44:9000/cake-land-server/8f66f9c9-a539-4e83-aac9-ea88730595a2")!)
        }
    }
}
