//
//  ProfileView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension ProfileView {
    var mainContainer: some View {
        ScrollView {
            VStack {
                imageBlockView
                buttonsBlockView
                productsBlockView
            }
        }
        .ignoresSafeArea()
        .background(Constants.bgColor)
    }
}

// MARK: - UI Subviews

private extension ProfileView {

    var buttonsBlockView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            HStack {
                if viewModel.isCurrentUser {
                    MessageButton(
                        title: Constants.createProductTitle,
                        imgString: Constants.createProductImg,
                        action: viewModel.didTapCreateProduct
                    )
                    IconButton(
                        iconname: Constants.gearButtonImg,
                        action: viewModel.didTapOpenSettings
                    )
                    IconButton(
                        iconname: Constants.notificationImg,
                        action: viewModel.didTapOpenMap
                    )
                } else {
                    MessageButton(
                        title: Constants.writeMessageTitle,
                        imgString: Constants.writeMessageImg,
                        action: viewModel.didTapWriteMessage
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: max(60 - minY, 0))
        }
        .offset(y: -36)
        .zIndex(1)
    }

    @ViewBuilder
    var imageBlockView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let iscrolling = minY > 0
            VStack {
                TLImageView(
                    configuration: viewModel.configureHeaderImage()
                )
                .frame(
                    width: geo.size.width,
                    height: iscrolling ? 280 + minY : 280
                )
                .offset(y: iscrolling ? -minY : 0)
                .blur(radius: iscrolling ? 0 + minY / 60 : 0)
                .scaleEffect(iscrolling ? 1 + minY / 2000 : 1)
                .overlay(alignment: .bottom) {
                    ZStack {
                        TLImageView(
                            configuration: viewModel.configureAvatarImage()
                        )
                        .frame(width: 110, height: 110)

                        Circle().stroke(lineWidth: 6)
                            .fill(Constants.bgColor)
                    }
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .offset(y: 25)
                    .offset(y: iscrolling ? -minY : 0)
                }

                Group {
                    VStack(spacing: 6) {
                        Text(viewModel.user.name.uppercased())
                            .bold()
                            .font(.title)
                        Text(viewModel.user.mail).font(.callout)
                            .foregroundStyle(Constants.userMailColor)
                            .multilineTextAlignment(.center)
                            .frame(width: geo.size.width)
                            .lineLimit(1)
                            .fixedSize()
                            .foregroundStyle(Constants.textColor)
                    }
                    .offset(y: iscrolling ? -minY : 0)
                }
                .padding(.vertical, 18)
            }
        }
        .frame(height: 400)
    }

    var productsBlockView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(viewModel.user.cakes) { cake in
                TLProductCard(
                    configuration: viewModel.configureProductCard(for: cake)
                ) { isSelected in
                    viewModel.didTapCakeLikeButton(cake: cake, isSelected: isSelected)
                }
                .onTapGesture {
                    viewModel.didTapCakeCard(with: cake)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
    }
}

// MARK: - Helpers

private struct MessageButton: View {
    var title: String
    var imgString: String
    var action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Label(title, systemImage: imgString)
                .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
                .font(.callout)
                .bold()
                .foregroundStyle(.black)
                .frame(width: 240, height: 45)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
        })
    }
}

private struct IconButton: View {
    let iconname: UIImage?
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: iconname ?? UIImage())
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(TLColor<IconPalette>.iconSecondary.color)
                .frame(width: 23, height: 23)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
        }
    }
}

// MARK: - Preview

#Preview("Mockable current user") {
    ProfileView(
        viewModel: ProfileViewModelMock(isCurrentUser: true)
    )
    .environment(Coordinator())
}

#Preview("Mockable not current") {
    ProfileView(
        viewModel: ProfileViewModelMock(isCurrentUser: false)
    )
    .environment(Coordinator())
}

// MARK: - Constants

private extension ProfileView {
    enum Constants {
        static let textColor = TLColor<TextPalette>.textPrimary.color
        static let userMailColor = TLColor<TextPalette>.textPrimary.color
        static let bgColor = TLColor<BackgroundPalette>.bgMainColor.color
        static let gearButtonImg = UIImage(systemName: "gear")
        static let notificationImg = UIImage(systemName: "location.north.circle")
        static let createProductTitle = String(localized: "Create a product")
        static let createProductImg = "plus.circle"
        static let writeMessageTitle = String(localized: "Message")
        static let writeMessageImg = "message"
    }
}
