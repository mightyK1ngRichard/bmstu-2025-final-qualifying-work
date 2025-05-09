//
//  ChatView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

extension ChatView {
    var mainContainer: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottom) {
                ScrollView {
                    messagesContainer

                    HStack { Spacer() }
                        .id(Constants.scrollIdentifier)
                        .padding(.bottom, 50)
                }

                textFieldBlock
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
            }
            .frame(maxHeight: .infinity)
            .background {
                backgroundView
                    .ignoresSafeArea()
            }
            .onAppear {
                proxy.scrollTo(Constants.scrollIdentifier, anchor: .bottom)
            }
            .onChange(of: viewModel.lastMessageID) { _, _ in
                withAnimation {
                    proxy.scrollTo(Constants.scrollIdentifier, anchor: .bottom)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                headerInfo
            }
            ToolbarItem(placement: .topBarTrailing) {
                interlocutorAvatar
            }
        }
    }
}

private extension ChatView {
    var messagesContainer: some View {
        LazyVStack {
            ForEach(viewModel.messages) { message in
                MessageBubble(message: message)
                    .padding(.horizontal, 8)
            }
        }
    }

    var backgroundView: some View {
        LinearGradient(
            colors: Constants.gradientBackgroundColor,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .mask {
            Constants.tgBackground
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var textFieldBlock: some View {
        HStack {
            Constants.paperClip

            TextField(Constants.placeholder, text: $viewModel.uiProperties.messageText)
                .padding(.vertical, 6)
                .padding(.horizontal, 13)
                .background(Constants.textFieldBackgroundColor, in: .rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                        .fill(Constants.textFieldStrokeColor)
                }

            if viewModel.uiProperties.messageText.isEmpty {
                Constants.record
                    .frame(width: 22, height: 22)

            } else {
                Button(action: viewModel.didTapSendMessageButton, label: {
                    Image(systemName: Constants.paperplaneImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Constants.iconColor)
                })
            }
        }
        .padding(.horizontal, 8)
    }

    var headerInfo: some View {
        VStack {
            Text(viewModel.interlocutor.titleName)
                .style(17, .medium, TLColor<TextPalette>.textPrimary.color)
            Text(viewModel.interlocutor.mail)
                .style(13, .regular, TLColor<TextPalette>.textSecondary.color)
        }
    }

    var interlocutorAvatar: some View {
        TLImageView(
            configuration: viewModel.configureInterlocutorAvatar()
        )
        .frame(width: 37, height: 37)
        .clipShape(.circle)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChatView(
            viewModel: ChatViewModelMock()
        )
    }
    .environment(Coordinator())
}

// MARK: - Constants

private extension ChatView {
    enum Constants {
        static let scrollIdentifier = "EMPTY"
        static let imageSize: CGFloat = 200
        static let imageCornerRadius: CGFloat = 20
        static let tgBackground = Image("tg_layer")
        static let paperClip = Image("paperClip")
        static let record = Image("record")
        static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
        static let textColor: Color = TLColor<TextPalette>.textPrimary.color
        static let textFieldBackgroundColor = TLColor<BackgroundPalette>.bgPrimary.color
        static let textFieldStrokeColor = TLColor<SeparatorPalette>(hexLight: 0xD1D1D1, hexDark: 0x3A3A3C).color
        static let iconColor = Color(red: 127/255, green: 127/255, blue: 127/255)
        static let placeholder = String(localized: "Message")
        static let paperplaneImg = "paperplane"
        static let gradientBackgroundColor: [Color] = [
            Color(red: 168/255, green: 255/255, blue: 59/255),
            Color(red: 111/255, green: 135/255, blue: 255/255),
            Color(red: 215/255, green: 161/255, blue: 255/255),
            Color(red: 113/255, green: 190/255, blue: 255/255),
        ]
    }
}
