//
//  OrderListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

struct OrderListView: View {
    @State var viewModel: OrderListViewModel
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        commonContainerView
            .background(TLColor<BackgroundPalette>.bgMainColor.color)
            .navigationTitle("My orders")
            .onFirstAppear {
                viewModel.setCoordinators(coordinator)
                viewModel.fetchData()
            }
            .navigationDestination(for: OrderListModel.Screens.self) { screen in
                switch screen {
                case let .orderDetails(order):
                    viewModel.assemblyOrderDetails(orderEntity: order)
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
            shimmeringContainer
        case .finished:
            contentView
        case let .error(content):
            errorView(content: content)
        }
    }

    @ViewBuilder
    var contentView: some View {
        if viewModel.orders.isEmpty {
            emptyView
        } else {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.orders, id: \.id) { order in
                        OrderCell(configuration: viewModel.configureOrderCell(order: order))
                            .onTapGesture {
                                viewModel.didTapOrderCell(order: order)
                            }
                    }
                }
                .padding()
            }
        }
    }

    var shimmeringContainer: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(1...6, id: \.self) { _ in
                    ShimmeringView()
                        .clipShape(.rect(cornerRadius: 8))
                        .frame(height: 164)
                }
            }
            .padding()
        }
    }

    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "shippingbox")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.gray.opacity(0.6))

            Text("Заказов пока нет")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Когда вы сделаете заказ, он появится здесь.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    func errorView(content: ErrorContent) -> some View {
        TLErrorView(
            configuration: .init(from: content),
            action: viewModel.fetchData
        )
        .padding()
        .frame(minHeight: .infinity)
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
    let auth = AuthGrpcServiceImpl(
        configuration: AppHosts.auth,
        networkService: networkService
    )

    return NavigationStack(path: $coordinator.navPath) {
        OrderListView(
            viewModel: OrderListViewModel(
                cakeService: CakeGrpcServiceImpl(
                    configuration: AppHosts.cake,
                    authService: auth,
                    networkService: networkService
                ),
                orderService:  OrderGrpcServiceImpl(
                    configuration: AppHosts.order,
                    authService: auth,
                    networkService: networkService
                ),
                imageProvider: ImageLoaderProviderImpl()
            )
        )
    }
    .environment(coordinator)
}
