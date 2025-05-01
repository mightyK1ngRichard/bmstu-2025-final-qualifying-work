//
//  ProductsGridView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension ProductsGridView {

    @ViewBuilder
    var mainContainer: some View {
        contentView
            .toolbar {
                tabBarItems
            }
            .sheet(isPresented: $viewModel.uiProperties.showBottomSheet) {
                bottomSheetContent
                    .presentationDragIndicator(.visible)
            }
    }

}

// MARK: - UI Subviews

private extension ProductsGridView {

    @ViewBuilder
    var contentView: some View {
        if viewModel.displayedCakes.isEmpty {
            emptyContainer
        } else {
            scrollableContainer
        }
    }

    var emptyContainer: some View {
        GroupBox {
            Image(.cakeLogo)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundStyle(Constants.emptyImageColor)
                .padding(.horizontal)

            Text(Constants.emptyText)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
        }
        .backgroundStyle(
            TLColor<BackgroundPalette>.bgCommentView.color
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.bgColor)
    }

    var scrollableContainer: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                ForEach(viewModel.displayedCakes) { cake in
                    TLProductCard(
                        configuration: viewModel.configureProductCard(cake: cake)
                    ) { isSelected in
                        viewModel.didTapProductLikeButton(cake: cake, isSelected: isSelected)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.didTapProductCard(cake: cake)
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal, 8)
        }
        .background(Constants.bgColor)
    }

    func tabView(
        title: String,
        imageResource: ImageResource,
        action: @escaping TLVoidBlock
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 7) {
                Image(imageResource)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(TLColor<IconPalette>.iconDarkWhite.color)

                Text(title)
                    .style(11, .regular)
            }
        }
    }

}

// MARK: - Tab Bar Items

private extension ProductsGridView {

    @ViewBuilder
    var tabBarItems: some View {
        tabView(
            title: viewModel.uiProperties.selectedSortMode.rawValue.capitalized,
            imageResource: .sort,
            action: viewModel.didTapSortButton
        )

        tabView(
            title: "Filters",
            imageResource: .filter,
            action: viewModel.didTapFilterButton
        )
    }

}

// MARK: - Bottom Sheet

private extension ProductsGridView {

    @ViewBuilder
    var bottomSheetContent: some View {
        switch viewModel.uiProperties.bottomSheetKind {
        case .filter:
            filterSheetContent
                .presentationDetents([.height(300)])
        case .sort:
            sortSheetContent
                .presentationDetents([.height(250)])
        }
    }

    var filterSheetContent: some View {
        VStack(spacing: 38) {
            sliderView
            colorsView
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
        .background(Constants.bgColor)
        .overlay {
            if viewModel.uiProperties.showFilterLoader {
                ProgressView()
            }
        }
    }

    var sortSheetContent: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.uiProperties.sortModes) { sortMode in
                Button(sortMode.rawValue) {
                    viewModel.didSelectedSortMode(mode: sortMode)
                }
                .buttonStyle(TableRowStyle())
            }
        }
        .padding(.top)
        .background(Constants.bgColor)
    }

}

// MARK: - Filter Subviews

private extension ProductsGridView {

    var sliderView: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("Price range: \(Int(viewModel.uiProperties.priceRange)) \(StringConstants.rub)")
                .style(16, .semibold)

            Slider(
                value: $viewModel.uiProperties.priceRange,
                in: 0...viewModel.uiProperties.maxPrice
            ) {
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("\(Int(viewModel.uiProperties.maxPrice)) \(StringConstants.rub)")
            }
            .tint(Constants.iconRed)
        }
        .padding(.horizontal)
    }

    var colorsView: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("Colors")
                .style(16, .semibold)
                .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(viewModel.colors) { colorCell in
                        circleCell(for: colorCell)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    func circleCell(for cell: ProductsGridModel.ColorCell) -> some View {
        let isSelected = viewModel.cellIsSelected(for: cell)

        Button {
            withAnimation {
                viewModel.didTapColorCell(with: cell)
            }
        } label: {
            Circle()
                .fill(Color(uiColor: cell.uiColor))
                .frame(width: 36, height: 36)
                .padding(isSelected ? 4 : 0)
                .overlay {
                    if isSelected {
                        Circle()
                            .stroke(lineWidth: 1)
                            .fill(Constants.colorCell)
                    }
                }
        }
    }

}

// MARK: - Preview

#if DEBUG
import NetworkAPI
#endif

#Preview {
    NavigationStack {
        ProductsGridView(
            viewModel: ProductsGridViewModelMock(
                cakeService: CakeGrpcServiceImpl(
                    configuration: AppHosts.cake,
                    networkService: NetworkServiceImpl()
                )
            )
        )
    }
    .environment(Coordinator())
}

// MARK: - Constants

private extension ProductsGridView {

    enum Constants {
        static let bgColor: Color = TLColor<BackgroundPalette>.bgMainColor.color
        static let iconRed: Color = TLColor<IconPalette>.iconRed.color
        static let emptyText = String(localized: "Nothing found")
        static let emptyImageColor = TLColor<IconPalette>.iconPrimary.color
        static let colorCell = TLColor<SeparatorPalette>.colorCell.color
    }
}

private struct TableRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(configuration.isPressed ? TLColor<BackgroundPalette>.bgRed.color : .clear)
            .contentShape(.rect)
    }
}
