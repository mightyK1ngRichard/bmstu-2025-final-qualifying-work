//
//  CreateProductView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
#if DEBUG
import NetworkAPI
#endif

struct CreateProductView: View {
    @State var viewModel: CreateProductDisplayLogic & CreateProductViewModelInput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
        }
    }
}

// MARK: - Preview

#Preview {
    CreateProductAssembler.assemble(
        cakeProvider: CakeGrpcServiceImpl(
            configuration: AppHosts.cake,
            networkService: NetworkServiceImpl()
        ),
        imageProvider: ImageLoaderProviderImpl()
    )
    .environment(Coordinator())
}
