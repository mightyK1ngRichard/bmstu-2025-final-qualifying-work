//
//  CakeDetailsView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import SwiftUI

extension CakeDetailsView {
    var mainContainer: some View {
        ScrollView {
            VStack(spacing: 22) {
                imagesCarousel
                descriptionContainer
                fillingsContainer
                moreInfoContainer
                similarProductsContainer
            }
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .navigationTitle(viewModel.cakeModel.cakeName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .overlay {
            progressView
        }
        .blurredSheet(
            .init(TLColor<BackgroundPalette>.bgMainColor.color),
            show: $viewModel.bindingData.showSheet,
            onDismiss: {
                viewModel.bindingData.selectedFilling = nil
            }
        ) {
            fillingDetailsView
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
    }
}

// MARK: - Private UI Subviews

extension CakeDetailsView {
    @ViewBuilder
    var progressView: some View {
        if viewModel.bindingData.isLoading {
            ZStack {
                Color.black.opacity(0.35)
                    .ignoresSafeArea(edges: [.bottom])
                ProgressView()
                    .tint(.white)
            }
        }
    }

    var backButton: some View {
        Button {
            viewModel.didTapBackButton()
        } label: {
            Image(.chevronLeft)
                .renderingMode(.template)
                .foregroundStyle(TLColor<IconPalette>.iconPrimary.color)
        }
    }

    var imagesCarousel: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                TLImageView(
                    configuration: viewModel.configurePreviewImageViewConfiguration()
                )
                .frame(width: 275, height: 473)

                ForEach(viewModel.cakeModel.thumbnails) { thumbnail in
                    TLImageView(
                        configuration: viewModel.configureImageViewConfiguration(for: thumbnail)
                    )
                    .frame(width: 275, height: 473)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    var descriptionContainer: some View {
        TLProductDescriptionView(
            configuration: viewModel.configureProductDescriptionConfiguration()
        )
    }

    @ViewBuilder
    var fillingDetailsView: some View {
        if let filling = viewModel.bindingData.selectedFilling {
            ScrollView {
                FillingDetailView(
                    configuration: viewModel.configureFillingDetails(for: filling)
                )
            }
            .presentationDetents([.medium])
        }
    }

    var fillingsContainer: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Constants.fillingsBlockHeaderTitle)
                .style(18, .semibold)
                .padding(.leading, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(viewModel.cakeModel.fillings) { filling in
                        VStack {
                            TLImageView(
                                configuration: .init(imageState: filling.imageState)
                            )
                            .frame(height: 100)
                            .clipShape(.rect(cornerRadius: 8))

                            Text(filling.name)
                                .style(16, .semibold)
                                .lineLimit(1)
                        }
                        .containerRelativeFrame(.horizontal) { dimenstion, _ in
                            let width = (dimenstion - 8) / 2
                            return width > 0 ? width : 200
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            viewModel.didTapFilling(with: filling)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    var similarProductsContainer: some View {
        if !viewModel.cakeModel.similarCakes.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(Constants.similarBlockHeaderTitle)
                    .style(18, .semibold)
                    .padding(.leading, 16)

                similarProductsCarousel
            }
        }
    }

    var similarProductsCarousel: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                ForEach(viewModel.cakeModel.similarCakes) { simillarCake in
                    TLProductCard(
                        configuration: viewModel.configureSimilarProductConfiguration(for: simillarCake)
                    ) { isSelected in
                        viewModel.didTapCakeLike(model: simillarCake, isSelected: isSelected)
                    }
                    .frame(width: 148)
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.didTapSimilarCake(model: simillarCake)
                    }
                }
            }
            .padding(.leading, 17)
        }
        .scrollIndicators(.hidden)
    }

    var moreInfoContainer: some View {
        VStack {
            Divider()
            moreInfoCell(text: Constants.ratingReviewsTitle) {
                viewModel.didTapRatingReviewsButton()
            }
            if viewModel.showOwnerButton {
                moreInfoCell(text: Constants.sellerInfoTitle) {
                    viewModel.didTapSellerInfoButton()
                }
            }
        }
    }

    @ViewBuilder
    func moreInfoCell(text: String, action: @escaping TLVoidBlock) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .regular))
                    .tint(TLColor<TextPalette>.textPrimary.color)
                Spacer()
                Image(.chevronRight)
                    .renderingMode(.template)
                    .tint(TLColor<TextPalette>.textPrimary.color)
                    .frame(width: 16, height: 16)
            }
            .frame(height: 48)
        }
        .padding(.horizontal)
        Divider()
    }
}

// MARK: - Preview

#Preview {
    @Previewable
    @State var coordinator = Coordinator()
    NavigationStack(path: $coordinator.navPath) {
        CakeDetailsView(viewModel: CakeDetailsViewModelMock(isOwnedByUser: false))
    }
    .environment(coordinator)
}

// MARK: - Constants

private extension CakeDetailsView {
    enum Constants {
        static let fillingsBlockHeaderTitle = String(localized: "Fillings")
        static let similarBlockHeaderTitle = String(localized: "You can also like this")
        static let ratingReviewsTitle = String(localized: "Rating&Reviews")
        static let sellerInfoTitle = String(localized: "Seller Info")
        static let buyButtonTitle = String(localized: "Make an order")
        static let deleteButtonTitle = String(localized: "Delete product")
    }
}
