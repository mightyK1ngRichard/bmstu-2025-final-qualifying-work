//
//  TestAuthAPIView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation
import NetworkAPI
import SwiftUI

#Preview {
    Button("TestAuthAPIView") {
        let api = AuthGrpcServiceImpl(
            configuration: AppHosts.auth,
            networkService: NetworkServiceImpl()
        )

        Task {
            let _ = try? await api.login(
                req: .init(
                    email: "dimapermyakov55@gmail.com",
                    password: "12345678"
                )
            )
        }
    }
}
