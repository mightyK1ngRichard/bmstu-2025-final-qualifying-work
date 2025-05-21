//
//  AddFillingsAndCategories.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem
import Core

#if DEBUG
import NetworkAPI
#endif

struct AddFillingsAndCategoriesView: View {
    @State var viewModel: AddFillingsAndCategoriesViewModel
    var backAction: TLVoidBlock

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            fillingsContainer
            categoriesContainer
        }
        .onAppear {
            viewModel.fetchFittings()
            viewModel.fetchCategories()
        }
    }
}

// MARK: - UI Subviews

private extension AddFillingsAndCategoriesView {

    var fillingsContainer: some View {
        VStack(alignment: .leading, spacing: 17) {
            sectionTitle(String(localized: "Choose fillings"))
            scrollableImages {
                ForEach(viewModel.fillings, id: \.id) { filling in
                    fillingCard(for: filling).onTapGesture {
                        viewModel.didTapFillingCard(with: filling)
                    }
                }
            }
        }
    }

    var categoriesContainer: some View {
        VStack(alignment: .leading, spacing: 17) {
            sectionTitle(String(localized: "Choose categories") )
            scrollableImages {
                ForEach(viewModel.categories, id: \.id) { category in
                    categoryCard(for: category).onTapGesture {
                        viewModel.didTapCategoryCard(with: category)
                    }
                }
            }
        }
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .style(17, .medium)
            .padding(.horizontal)
    }

    func scrollableImages<Content: View>(_ cards: () -> Content) -> some View {
        ScrollView(.horizontal) {
            HStack {
                cards()
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }

    func fillingCard(for filling: Filling) -> some View {
        VStack {
            TLImageView(
                configuration: viewModel.configureImageView(
                    imageState: filling.imageState
                )
            )
            .frame(height: 130)
            .overlay {
                if viewModel.showFillingOverlay(for: filling) {
                    selectedOverlayView
                }
            }
            .clipShape(.rect(cornerRadius: 12))

            Text(filling.name)
                .style(14, .bold)
        }
        .frame(width: 200)
        .contentShape(.rect)
    }

    func categoryCard(for category: Category) -> some View {
        VStack {
            TLImageView(
                configuration: viewModel.configureImageView(
                    imageState: category.imageState
                )
            )
            .frame(height: 130)
            .overlay {
                if viewModel.showCategoryOverlay(for: category) {
                    selectedOverlayView
                }
            }
            .clipShape(.rect(cornerRadius: 12))

            Text(category.name)
                .style(14, .bold)
        }
        .frame(width: 200)
        .contentShape(.rect)
    }

    var selectedOverlayView: some View {
        ZStack {
            Color.black.opacity(0.4)

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }

    var backButton: some View {
        Button(action: backAction, label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(TLColor<IconPalette>.iconPrimary.color)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.bar, in: .rect(cornerRadius: 10))
        })
    }
}
