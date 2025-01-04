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
        if viewModel.cakes.isEmpty {
            emptyContainer
        } else {
            scrollableContainer
        }
    }
}

// MARK: - UI Subviews

private extension ProductsGridView {

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
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 2),
                pinnedViews: [.sectionHeaders]
            ) {
                Section {
                    ForEach(viewModel.cakes) { cake in
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
                } header: {
                    // TODO: Добавить секцию фильтров
                }
            }
            .padding(.horizontal, 8)
        }
        .background(Constants.bgColor)
    }
}

// MARK: - Preview

#Preview {
    ProductsGridView(
        viewModel: ProductsGridViewModelMock()
    )
    .environment(Coordinator())
}

// MARK: - Constants

private extension ProductsGridView {

    enum Constants {
        static let bgColor: Color = TLColor<BackgroundPalette>.bgMainColor.color
        static let emptyText = String(localized: "Nothing found")
        static let emptyImageColor = TLColor<IconPalette>.iconPrimary.color
    }
}
