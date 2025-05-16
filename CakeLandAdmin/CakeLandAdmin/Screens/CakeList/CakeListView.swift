//
//  CakeListView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 14.05.2025.
//

import SwiftUI

struct CakeListView: View {
    @State var viewModel: CakeListViewModel
    @State private var isExpanded = true
    @State private var isHovered = false

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

            DisclosureGroup(isExpanded: $isExpanded) {
                CakeStatusChartView(data: viewModel.cakeStatusDistribution)
            } label: {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.accentColor)
                    Text("График статусов тортов")
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
        .frame(minWidth: 600, minHeight: 800)
}
