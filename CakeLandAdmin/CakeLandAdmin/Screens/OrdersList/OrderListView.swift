//
//  OrderListView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import NetworkAPI
import SwiftUI
import Charts
import MacDS

struct OrderListView: View {
    @State var viewModel: OrdersListViewModel
    @State private var coordinator = Coordinator()
    @State private var selectedOrder: OrderModel?
    @State private var isHovered = false
    @State private var isExpanded = true

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
            errorContent: viewModel.bindingData.alert.content,
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

    var controlContainer: some View {
        HStack {
            sortMenu
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
            .keyboardShortcut(.defaultAction)
            .disabled(viewModel.updatedStatuses.isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    var miniChartView: some View {
        Chart {
            ForEach(viewModel.statusCountsSorted, id: \.status) { item in
                BarMark(
                    x: .value("Orders Count", item.count),
                    y: .value("Status", item.status.title)
                )
                .foregroundStyle(item.status.textColor)
                .cornerRadius(3)
                .annotation(position: .trailing) {
                    Text("\(item.count)")
                        .font(.caption2)
                        .foregroundColor(.primary)
                }
            }
        }
        .chartXAxisLabel(position: .bottom) {
            Text("Число заказов")
                .font(.footnote)
        }
        .chartYAxisLabel(position: .leading) {
            Text("Статус заказа")
                .font(.footnote)
        }
        .frame(height: 200)
        .padding(.horizontal, 8)
    }

    var mainContainer: some View {
        VStack(spacing: 0) {
            controlContainer

            DisclosureGroup(isExpanded: $isExpanded) {
                miniChartView
            } label: {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.accentColor)
                    Text("График статусов заказов")
                        .font(.headline)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isHovered && !isExpanded ? Color(.darkGray).opacity(0.3) : Color(.clear))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(
                        isHovered ? Color.accentColor : Color.gray.opacity(0.2),
                        lineWidth: 1
                    )
            )
            .padding(.horizontal)
            .padding(.bottom, 8)
            .contentShape(.rect)
            .onTapGesture {
                isExpanded.toggle()
            }
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }

            ordersTable
        }
    }

    var sortMenu: some View {
        Menu("Сортировать по дате создания") {
            Button("По возрастанию") {
                viewModel.bindingData.sortDirection = .ascending
            }

            Button("По убыванию") {
                viewModel.bindingData.sortDirection = .descending
            }
        }
    }

    var ordersTable: some View {
        Table(viewModel.sortedOrders, selection: $viewModel.bindingData.selectedOrder) {
            TableColumn("ID") { order in
                Text(order.id)
            }

            TableColumn("Цена") { order in
                Text(String(format: "%.2f ₽", order.totalPrice))
            }

            TableColumn("Дата формирования") { order in
                Text(order.createdAt.formattedDDMMYYYYHHmm)
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
