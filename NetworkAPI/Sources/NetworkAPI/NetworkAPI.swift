//
//  NetworkAPI.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 15.02.2025.
//

import SwiftUI

struct TestAuthAPIView: View {
    var body: some View {
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
}

#Preview {
    TestAuthAPIView()
}
