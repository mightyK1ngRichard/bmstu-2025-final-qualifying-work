//
//  CreateProductView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension CreateProductView {

    var mainContainer: some View {
        ZStack {
            if viewModel.uiProperties.currentPage == 1 {
                viewModel.assembleCreateCakeInfoView()
                    .transition(.flip)
            } else if viewModel.uiProperties.currentPage == 2 {
                viewModel.assemblyFillingsAndCategoriesView()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 100)
                    .transition(.reverseFlip)
            } else if viewModel.uiProperties.currentPage == 3 {
                viewModel.assemblyAddProductImages()
                    .transition(.flip)
            } else if viewModel.uiProperties.currentPage == 4 {
                viewModel.assemblyProductResultScreen()
                    .transition(.slide)
            }
        }
        .navigationBarBackButtonHidden()
        .overlay(alignment: .topLeading) {
            backButton
        }
        .overlay(alignment: .bottom) {
            nextButton
                .padding(.bottom)
                .disabled(!viewModel.uiProperties.nextButtonIsEnabled)
                .opacity(viewModel.uiProperties.nextButtonIsEnabled ? 1.0 : 0.4)
        }
        .background(Constants.bgColor)
        .defaultAlert(
            title: viewModel.uiProperties.alertTitle,
            message: viewModel.uiProperties.alertMessage,
            isPresented: $viewModel.uiProperties.showAlert
        )
    }
}

private extension CreateProductView {

    var nextButton: some View {
        Button {
            if viewModel.uiProperties.currentPage == 1 {
                withAnimation(.linear(duration: 0.6)) {
                    viewModel.didCloseProductInfoSreen()
                }
            } else if viewModel.uiProperties.currentPage == 2 {
                withAnimation(.linear(duration: 0.6)) {
                    viewModel.didTapCloseFillingCategoriesScreen()
                }
            } else if viewModel.uiProperties.currentPage == 3 {
                withAnimation(.linear(duration: 0.6)) {
                    viewModel.didCloseProductImagesScreen()
                }
            } else if viewModel.uiProperties.currentPage == 4 {
                withAnimation(.linear(duration: 0.6)) {
                    viewModel.didCloseResultScreen()
                }
            }
        } label: {
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 60, height: 60)
                .foregroundStyle(Constants.iconColor)
                .background(.white, in: .circle)
                .overlay {
                    circleBlock
                        .padding(-5)
                }
        }
    }

    var backButton: some View {
        Button {
            withAnimation(.linear(duration: 0.6)) {
                viewModel.didTapBackScreen()
            }
        } label: {
            Image(systemName: Constants.backImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .bold()
                .padding(.leading, 8)
                .padding(.top, 10)
        }
    }

    var circleBlock: some View {
        ZStack {
            Circle()
                .stroke(Constants.textColor.opacity(0.06), lineWidth: 4)

            Circle()
                .trim(
                    from: 0,
                    to: CGFloat(viewModel.uiProperties.currentPage) / CGFloat(viewModel.uiProperties.totalCount)
                )
                .stroke(Constants.circleColor.gradient, lineWidth: 4)
                .rotationEffect(.init(degrees: -90))
        }
    }

    @ViewBuilder
    var alertButtonsContainer: some View {
        Button("Create", action: viewModel.didTapCreateProduct)
        Button("Cancel", role: .cancel, action: viewModel.didTapCancelProduct)
        Button("Delete", role: .destructive, action: viewModel.didTapDeleteProduct)
    }
}

// MARK: - Constants

private extension CreateProductView {

    enum Constants {
        static let textColor = TLColor<TextPalette>.textPrimary.color
        static let circleColor = TLColor<IconPalette>.iconRed.color
        static let iconColor = TLColor<IconPalette>.iconRed.color
        static let bgColor = TLColor<BackgroundPalette>.bgMainColor.color
        static let backImg = "chevron.left"
    }
}
