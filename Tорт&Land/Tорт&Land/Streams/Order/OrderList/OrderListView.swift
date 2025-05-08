//
//  OrderListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct OrderListView: View {
    @State var viewModel: OrderListViewModel
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                commonContainerView
            }
            .padding()
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .navigationTitle("My orders")
        .onFirstAppear {
            viewModel.setCoordinators(coordinator)
            viewModel.fetchData()
        }
        .navigationDestination(for: OrderListModel.Screens.self) { screen in
            switch screen {
            case let .orderDetails(order: order):
                Text(order.id)
            }
        }
    }
}

// MARK: - UI Subviews

private extension OrderListView {

    @ViewBuilder
    var commonContainerView: some View {
        switch viewModel.uiProperties.state {
        case .initial, .loading:
            ForEach(1...6, id: \.self) { _ in
                ShimmeringView()
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(height: 164)
            }
        case .finished:
            contentView
        case let .error(message):
            errorView(message: message)
        }
    }

    @ViewBuilder
    var contentView: some View {
        ForEach(viewModel.orders, id: \.id) { order in
            OrderCell(configuration: viewModel.configureOrderCell(order: order))
                .onTapGesture {
                    viewModel.didTapOrderCell(order: order)
                }
        }
    }

    func errorView(message: String) -> some View {
        TLErrorView(
            configuration: .init(
                kind: .customError("Network error", message)
            ),
            action: viewModel.fetchData
        )
    }

}

// MARK: - Preview

#if DEBUG
import NetworkAPI
#endif

#Preview {
    @Previewable
    @State var coordinator = Coordinator()
    let networkService = NetworkServiceImpl()
    networkService.setRefreshToken(CommonMockData.refreshToken)

    return NavigationStack(path: $coordinator.navPath) {
        OrderListView(
            viewModel: OrderListViewModel(
                orderService: OrderGrpcServiceImpl(
                    configuration: AppHosts.order,
                    authService: AuthGrpcServiceImpl(
                        configuration: AppHosts.auth,
                        networkService: networkService
                    ),
                    networkService: networkService
                )
            )
        )
    }
    .environment(coordinator)
}
