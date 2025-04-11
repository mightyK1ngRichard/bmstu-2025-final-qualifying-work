//
//  ProfileView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
#if DEBUG
import NetworkAPI
#endif

struct ProfileView: View {
    @State var viewModel: ProfileDisplayLogic & ProfileViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.fetchUserData()
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    ProfileView(
        viewModel: ProfileViewModelMock()
    )
    .environment(Coordinator())
}

//#Preview("Network") {
//    ProfileView(
//        viewModel: ProfileViewModel(
//            user: CommonMockData.generateMockUserModel(id: 1),
//            imageLoader: ImageLoaderProviderImpl(),
//            profileService: ProfileGrpcServiceImpl(
//                configuration: AppHosts.profile,
//                networkService: {
//                    let networkImpl = NetworkServiceImpl()
//                    networkImpl.setAccessToken(accessToken)
//                    return networkImpl
//                }()
//            )
//        )
//    )
//    .environment(Coordinator())
//}
