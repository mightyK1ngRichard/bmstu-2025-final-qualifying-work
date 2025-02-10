//
//  testViwe.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation
import SwiftUI

#Preview {
    Button("Fetch data") {
        let api = AuthGrpcServiceImpl(
            configuration: AppHosts.auth,
            networkService: NetworkServiceImpl()
        )

        Task {
            do {
                let res = try await api.login(
                    req: .init(
                        email: "dimapermyakov55@gmail.com",
                        password: "123456789"
                    )
                )
                print("[DEBUG]: \(res)")
            } catch {
                print("[DEBUG]: \(error)")
            }
        }
    }
}
