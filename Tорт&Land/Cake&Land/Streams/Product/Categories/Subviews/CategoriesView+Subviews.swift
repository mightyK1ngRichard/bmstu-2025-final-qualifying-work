//
//  CategoriesView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

extension CategoriesView {
    var mainContainer: some View {
        VStack(spacing: 0) {
            navigationBarBlock
            customTabBar
            contentContainer
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .customAlert(
            errorContent: viewModel.uiProperties.alert.content,
            isPresented: $viewModel.uiProperties.alert.isShown
        ) {
            Button(StringConstants.loadSavedData) {
                viewModel.didTapMemoryCakes()
            }
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
                    withAnimation {
                        viewModel.didTapSearchToggle()
                    }
                } label: {
                    Image(uiImage: TLAssets.magnifier)
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
            Image(uiImage: TLAssets.magnifier)
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
                    withAnimation(.snappy) {
                        viewModel.didTapTab(tab: tab)
                    }
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

    @ViewBuilder
    var contentContainer: some View {
        switch viewModel.uiProperties.state {
        case .initial, .loading:
            loadingView
        case .finished:
            sectionsBlock
        case let .error(content):
            VStack {
                TLErrorView(
                    configuration: .init(from: content),
                    action: viewModel.onAppear
                )
                TLButton(StringConstants.loadSavedData, action: viewModel.didTapLoadSavedData)
            }
            .padding()
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
                        viewModel.didTapSectionCell(section: section, fromMemory: false)
                    }
                }
            }
            .padding(.top)
        }
    }

    var loadingView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(1...10, id: \.self) { _ in
                    ShimmeringView()
                        .frame(height: 100)
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
            .padding([.horizontal, .top])
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

// MARK: - Constants

private extension CategoriesView {
    enum Constants {
        static let navigationTitle = String(localized: "Categories")
        static let searchTitle = String(localized: "Search")
    }
}
