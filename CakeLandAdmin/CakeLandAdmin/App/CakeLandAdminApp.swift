//
//  CakeLandAdminApp.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 10.05.2025.
//

import SwiftUI

@main
struct CakeLandAdminApp: App {
    let manager = NetworkManager()
    var body: some Scene {
        WindowGroup {
            RootAssembler.assemble()
        }
    }
}
