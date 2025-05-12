//
//  OrderListView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import SwiftUI
import MacDS

struct OrderListView: View {
    @State var viewModel: OrdersListViewModel
    @State private var coordinator = Coordinator()
    @State private var selectedOrder: OrderModel?

    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            content.navigationDestination(for: OrdersListModel.Screens.self) { screen in
                openNextScreen(for: screen)
            }
        }
        .onFirstAppear {
            viewModel.setCoordinator(coordinator)
            viewModel.fetchOrders()
        }
        .defaultAlert(
            errorContent: viewModel.bindingData.alert.errorContent,
            isPresented: $viewModel.bindingData.alert.isShown
        )
    }
}

// MARK: - Navigation Destination

private extension OrderListView {
    func openNextScreen(for screen: OrdersListModel.Screens) -> some View {
        switch screen {
        case let .order(orderModel):
            viewModel.assembleOrderView(order: orderModel)
        }
    }
}

// MARK: - UI Subviews

private extension OrderListView {

    @ViewBuilder
    var content: some View {
        switch viewModel.bindingData.state {
        case .initial, .loading:
            ProgressView()
        case .finished:
            mainContainer
        case let .error(content):
            Text(content.title)
            Text(content.message)
        }
    }

    var mainContainer: some View {
        ordersTable
            .overlay(alignment: .bottomTrailing) {
                Button {
                    viewModel.didTapSave()
                } label: {
                    if viewModel.bindingData.saveButtonIsLoading {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Text("Save changes")
                    }
                }
                .padding()
                .keyboardShortcut(.defaultAction)
            }
    }

    var ordersTable: some View {
        Table(viewModel.orders, selection: $viewModel.bindingData.selectedOrder) {
            TableColumn("ID") { order in
                Text(order.id)
            }

            TableColumn("Начинка") { order in
                Text(order.filling.name)
            }

            TableColumn("Цена") { order in
                Text(String(format: "%.2f ₽", order.totalPrice))
            }

            TableColumn("Адрес") { order in
                Text(order.deliveryAddress.formattedAddress)
            }

            TableColumn("Дата доставки") { order in
                Text(order.deliveryDate.formatted(date: .abbreviated, time: .omitted))
            }

            TableColumn("Статус") { order in
                Picker("Статус", selection: viewModel.bindingForStatus(of: order)) {
                    ForEach(viewModel.bindingData.allStatuses, id: \.self) { status in
                        Text(status.title)
                            .foregroundStyle(status.textColor)
                            .tag(status)
                    }
                }
                .pickerStyle(.menu)
                .tint(order.status.textColor)
            }
        }
        .onChange(of: viewModel.bindingData.selectedOrder) { _, newValue in
            guard let newValue else { return }
            viewModel.didSelectOrderCell(orderID: newValue)
        }
    }

}

// MARK: - Preview

#Preview {
    NavigationStack {
        OrdersListAssembler.assemble(
            networkManager: NetworkManager(),
            imageProvider: ImageLoaderProviderImpl()
        )
    }
    .frame(width: 600, height: 350)
}
