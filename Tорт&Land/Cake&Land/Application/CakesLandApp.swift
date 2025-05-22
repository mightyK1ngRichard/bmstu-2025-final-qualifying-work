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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var startScreenControl = StartScreenControl()
    @Environment(\.scenePhase) private var scenePhase
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            RootAssembler.assemble(
                startScreenControl: startScreenControl,
                networkManager: AppDelegate.networkManager
            )
            .environment(startScreenControl)
            .onChange(of: scenePhase) { _, newPhase in
                switch newPhase {
                case .active:
                    print("[DEBUG]: App is active again")
                case .background:
                    print("[DEBUG]: App went to background")
                case .inactive:
                    print("[DEBUG]: App is inactive")
                @unknown default:
                    break
                }
            }
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

// MARK: - AppDelegate

final class AppDelegate: NSObject, UIApplicationDelegate {
    static var networkManager = NetworkManager()
    static func restartNetworkManager() {
        networkManager.closeConnections()
        networkManager = NetworkManager()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("[DEBUG]: App did finish launching")
        return true
    }
}

