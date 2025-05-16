//
//  MessageBubble.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

struct MessageBubble: View {
    let message: ChatModel.ChatMessage

    var body: some View {
        mainContainer
    }
}

// MARK: - Subviews

private extension MessageBubble {
    private var isYou: Bool { message.isYou }

    var mainContainer: some View {
        HStack(alignment: .bottom) {
            if !isYou {
                personeAvatar
            }

            VStack(alignment: .leading, spacing: 2) {
                if !isYou {
                    Text(message.user.titleName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.mint.gradient)
                        .padding(.leading, 10)
                }
                messageBottomTrailingView
                    .padding(.horizontal, 12)
            }
            .padding(.vertical, 6)
            .background(Constants.messageBackgroundColor, in: .rect(cornerRadius: 18))
            .frame(maxWidth: 330, alignment: isYou ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity, alignment: isYou ? .trailing : .leading)
    }

    var messageBottomTrailingView: some View {
        HStack(alignment: .bottom) {
            Text(message.message)
                .foregroundStyle(.white)

            HStack(spacing: 3) {
                Text(message.time)
                    .foregroundStyle(.white.opacity(0.63))
                    .font(.system(size: 11, weight: .semibold))

                if isYou {
                    message.state.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(message.state.imageColor)
                }
            }
        }
    }

    @ViewBuilder
    var personeAvatar: some View {
        switch message.user.avatarImage {
        case .empty, .error:
            Circle()
                .fill(.mint.gradient)
                .frame(width: 32, height: 32)
                .overlay {
                    Text("\(message.user.titleName.first?.description.uppercased() ?? "😎")")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                }
        default:
            TLImageView(
                configuration: .init(
                    imageState: message.user.avatarImage
                )
            )
            .frame(width: 32, height: 32)
            .clipShape(.circle)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    let kingUser = CommonMockData.generateMockUserModel(
        id: 1,
        name: "mightyK1ngRichard",
        avatar: .fetched(.uiImage(TLPreviewAssets.king))
    )
    let mashulaUser = CommonMockData.generateMockUserModel(
        id: 2,
        name: "kakashka",
        avatar: .fetched(.uiImage(TLPreviewAssets.user7))
    )

    VStack {
        MessageBubble(
            message: .init(
                id: "1",
                isYou: true,
                message: "Hi! 🤗 You can switch patterns and gradients in the settings.",
                user: kingUser,
                time: "10:10",
                state: .received
            )
        )
        MessageBubble(
            message: .init(
                id: "1",
                isYou: false,
                message: "Hi! 🤗 You can switch patterns and gradients in the settings.",
                user: kingUser,
                time: "10:10",
                state: .received
            )
        )
        MessageBubble(
            message: .init(
                id: "2",
                isYou: true,
                message: "Ошибка отправки сообщения",
                user: kingUser,
                time: "10:10",
                state: .error
            )
        )
        MessageBubble(
            message: .init(
                id: "2",
                isYou: true,
                message: "Сообщение отправляется",
                user: kingUser,
                time: "10:10",
                state: .progress
            )
        )
        MessageBubble(
            message: .init(
                id: "3",
                isYou: false,
                message: "Димуля умница. А Машуля какашка",
                user: mashulaUser,
                time: "10:10",
                state: .received
            )
        )
        MessageBubble(
            message: .init(
                id: "4",
                isYou: false,
                message: "У меня сломалась аватарка",
                user: CommonMockData.generateMockUserModel(
                    id: -1,
                    name: "сломанный пользователь",
                    avatar: .empty,
                    header: nil
                ),
                time: "10:10",
                state: .received
            )
        )
    }
}

#endif

// MARK: - MessageState

extension ChatModel.ChatMessage.MessageState {
    var image: Image {
        switch self {
        case .error: return Constants.errorImage
        case .received: return Constants.receivedImage
        case .progress: return Constants.progressImage
        }
    }

    var imageColor: Color {
        switch self {
        case .error: return Color(red: 1, green: 0, blue: 0)
        default: return .white.opacity(0.63)
        }
    }
}

// MARK: - Constants

private extension ChatModel.ChatMessage.MessageState {
    enum Constants {
        static let receivedImage = Image(uiImage: TLAssets.checkMark2)
        static let errorImage = Image(systemName: "exclamationmark.arrow.circlepath")
        static let progressImage = Image(systemName: "clock.arrow.circlepath")
    }
}

private extension MessageBubble {
    enum Constants {
        static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
        static let textFieldBackgroundColor = Color(red: 6/255, green: 6/255, blue: 6/255)
        static let textFieldStrokeColor = Color(red: 58/255, green: 58/255, blue: 60/255)
        static let bottomBackgroundColor = Color(red: 28/255, green: 28/255, blue: 29/255)
    }
}
