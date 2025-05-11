//
//  ProductResultScreen.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import DesignSystem
import Core

struct ProductResultScreen: View {
    @Bindable var viewModel: CreateProductViewModel
    var backAction: TLVoidBlock?

    var body: some View {
        ScrollView {
            imagesBlock
            TLProductDescriptionView(
                configuration: viewModel.configureTLProductDescriptionConfiguration()
            )

            VStack(spacing: 40) {
                fillingsContainer
                categoriesContainer
            }
            .padding(.top, 50)
            .padding(.bottom, 150)
        }
        .scrollIndicators(.hidden)
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .overlay(alignment: .topTrailing) {
            backButton
                .padding(.trailing, 8)
        }
    }
}

// MARK: - UI Subviews

private extension ProductResultScreen {

    var imagesBlock: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(viewModel.selectedImages, id: \.hashValue) { uiImage in
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 275, height: 413)
                            .clipped()

                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    var fillingsContainer: some View {
        VStack(alignment: .leading, spacing: 17) {
            sectionTitle("Selected fillings")
            scrollableImages {
                ForEach(viewModel.addFCViewModel.getSelectedFillings()) { filling in
                    fillingCard(for: filling)
                }
            }
        }
    }

    var categoriesContainer: some View {
        VStack(alignment: .leading, spacing: 17) {
            sectionTitle("Selected categories")
            scrollableImages {
                ForEach(viewModel.addFCViewModel.getSelectedCategories()) { category in
                    categoryCard(for: category)
                }
            }
        }
    }

    func fillingCard(for filling: Filling) -> some View {
        VStack {
            TLImageView(
                configuration: .init(imageState: filling.imageState)
            )
            .frame(height: 130)
            .clipShape(.rect(cornerRadius: 12))

            Text(filling.name)
                .style(14, .bold)
        }
        .frame(width: 200)
        .contentShape(.rect)
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .style(17, .medium)
            .padding(.horizontal)
    }

    func categoryCard(for category: Category) -> some View {
        VStack {
            TLImageView(
                configuration: .init(imageState: category.imageState)
            )
            .frame(height: 130)
            .clipShape(.rect(cornerRadius: 12))

            Text(category.name)
                .style(14, .bold)
        }
        .frame(width: 200)
        .contentShape(.rect)
    }

    var backButton: some View {
        Button {
            backAction?()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(TLColor<IconPalette>.iconPrimary.color)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.bar, in: .rect(cornerRadius: 10))
        }
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
}
