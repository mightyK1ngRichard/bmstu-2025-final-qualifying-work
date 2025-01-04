//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

@main
struct CakesLandApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModelMock())
        }
    }
}
