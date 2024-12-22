//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

@main
struct CakesLandApp: App {
    let viewModel = CakesListViewModelMock(delay: 2)

    var body: some Scene {
        WindowGroup {
            CakesListView(viewModel: viewModel)
        }
    }
}
