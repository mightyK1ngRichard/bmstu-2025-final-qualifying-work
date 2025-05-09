//
//  CategoriesView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

extension CategoriesView {
    var mainContainer: some View {
        VStack(spacing: 0) {
            navigationBarBlock
            customTabBar
            sectionsBlock
            errorView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .overlay {
            loadingView
        }
    }
}

// MARK: - UI Subviews

private extension CategoriesView {
    var navigationBarBlock: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewModel.didTapSearchToggle()
                } label: {
                    Image(.magnifier)
                        .renderingMode(.template)
                }
            }
            .font(.title2)
            .overlay {
                Text(Constants.navigationTitle)
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)

            if viewModel.uiProperties.showSearchBar {
                searchBar
            }
        }
        .onChange(of: viewModel.uiProperties.selectedTab) { oldValue, newValue in
            guard let newValue, oldValue != newValue else { return }
            viewModel.didUpdateSelectedTag(section: newValue)
        }
    }

    var searchBar: some View {
        HStack(spacing: 12) {
            Image(.magnifier)
                .renderingMode(.template)
                .foregroundStyle(TLColor<IconPalette>.iconSecondary.color)
            TextField(Constants.searchTitle, text: $viewModel.uiProperties.searchText)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 15)
        .background(TLColor<BackgroundPalette>.bgSearchBar.color, in: .capsule)
        .padding(.horizontal)
    }

    var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.tabs, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Text(tab.title)
                        .font(.system(size: 16 , weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .onTapGesture {
                    viewModel.didTapTab(tab: tab)
                }
            }
        }
        .tabMask(viewModel.uiProperties.tabBarProgess, count: CGFloat(viewModel.tabs.count))
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(viewModel.tabs.count)
                Rectangle()
                    .fill(TLColor<BackgroundPalette>.bgBasketColor.color)
                    .frame(width: capsuleWidth, height: 3)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(
                        x: viewModel.uiProperties.tabBarProgess * (size.width - capsuleWidth)
                    )
            }
        }
    }

    var sectionsBlock: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.tabs, id: \.rawValue) { tab in
                        if let categories = viewModel.sections[tab] {
                            scrollSections(
                                items: viewModel.filterData(categories: categories)
                            )
                            .id(tab)
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                }
                .scrollTargetLayout()
                .offsetX { value in
                    let progress = -value / (size.width * CGFloat(viewModel.tabs.count - 1))
                    viewModel.uiProperties.tabBarProgess = max(min(progress, 1), 0)
                }
            }
            .scrollPosition(id: $viewModel.uiProperties.selectedTab)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
        }
    }

    @ViewBuilder
    var errorView: some View {
        if let errorMessage = viewModel.uiProperties.errorMessage {
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title)
                Text(errorMessage)
                    .font(.body)
                Button("Reload data", action: viewModel.onAppear)
                    .buttonStyle(.bordered)
                Spacer()
            }
            .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
        }
    }

    func scrollSections(items: [CategoryCardModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { section in
                    TLCategoryCell(
                        configuration: .basic(imageState: section.imageState, title: section.title)
                    )
                    .padding(.horizontal)
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.didTapSectionCell(section: section)
                    }
                }
            }
            .padding(.top)
        }
    }

    @ViewBuilder
    var loadingView: some View {
        if viewModel.uiProperties.showLoading {
            ZStack {
                Color.black.opacity(0.5)
                ProgressView()
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Helpers

private extension CategoriesView {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader {
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    CategoriesView(
        viewModel: CategoriesViewModelMock()
    )
    .environment(Coordinator())
}

// MARK: - Constants

private extension CategoriesView {
    enum Constants {
        static let navigationTitle = String(localized: "Categories")
        static let searchTitle = String(localized: "Search")
    }
}
