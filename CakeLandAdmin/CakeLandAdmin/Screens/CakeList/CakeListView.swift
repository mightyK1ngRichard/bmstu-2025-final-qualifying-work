//
//  CakeListView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 14.05.2025.
//

import SwiftUI

struct CakeListView: View {
    @State var viewModel: CakeListViewModel

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.bindingData.screenState {
            case .initial, .loading:
                ProgressView()
            case .finished, .error:
                headerContainer
                cardsContainer
            }
        }
        .defaultAlert(
            errorContent: viewModel.bindingData.alert.content,
            isPresented: $viewModel.bindingData.alert.isShown
        )
        .onFirstAppear {
            viewModel.fetchCakes()
        }
    }
}

// MARK: - UI Subviews

private extension CakeListView {

    var headerContainer: some View {
        VStack(spacing: 0) {
            filterContainer
            CakeStatusChartView(data: viewModel.cakeStatusDistribution)
        }
        .clipShape(.rect(cornerRadius: 12))
    }

    var filterContainer: some View {
        HStack {
            Picker("Статус", selection: $viewModel.bindingData.selectedStatus) {
                ForEach(CakeStatus.allCases, id: \.hashValue) { status in
                    Text(status.title)
                        .tag(status)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 5)

            Button {
                viewModel.saveChanges()
            } label: {
                if viewModel.bindingData.showSaveButtonLoading {
                    ProgressView()
                        .controlSize(.mini)
                        .frame(width: 120)
                } else {
                    Text("Сохранить изменения")
                }
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.defaultAction)
            .disabled(viewModel.changedCakes.isEmpty)
        }
        .padding(.horizontal)
    }

    var cardsContainer: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 280, maximum: 400))
                ],
                spacing: 16
            ) {
                ForEach(viewModel.filteredCakeIndices, id: \.self) { index in
                    CakeCardView(cake: $viewModel.cakes[index], changePublisher: viewModel.cakeChangeSubject)
                        .padding(10)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
        }
    }

}

// MARK: - Preview

#Preview {
    CakeListAssembler
        .assemble(
            networkManager: NetworkManager(),
            imageProvider: ImageLoaderProviderImpl()
        )
        .frame(minWidth: 500)
}
