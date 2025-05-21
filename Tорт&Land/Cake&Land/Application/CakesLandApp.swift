//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI
import SwiftData

@main
struct CakesLandApp: App {
    @State private var startScreenControl = StartScreenControl()
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            RootAssembler.assemble(startScreenControl: startScreenControl)
                .environment(startScreenControl)
        }
        .modelContainer(container)
    }

    init() {
        print("[DEBUG]: \(URL.applicationSupportDirectory.path(percentEncoded: false))")
        let shema = Schema([SDCake.self])
        let config = ModelConfiguration("CakesLand", schema: shema)
        do {
            self.container = try ModelContainer(for: shema, configurations: config)
        } catch {
            fatalError("could not initialize ModelContainer: \(error)")
        }
    }
}
