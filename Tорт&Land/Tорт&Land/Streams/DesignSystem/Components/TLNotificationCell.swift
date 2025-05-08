//
//  TLNotificationCell.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

extension TLNotificationCell {
    struct Configuration: Hashable {
        var notification: NotificationsListModel.NotificationModel?
        var isShimmering = false
    }
}

struct TLNotificationCell: View {
    var configuration: Configuration
    @State private var offsetX: CGFloat = .zero
    @State private var showTrash = false
    var deleteHandler: TLStringBlock?

    var body: some View {
        if configuration.isShimmering {
            shimmeringContainer
        } else {
            mainContainer
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if offsetX > -16 || -offsetX > Constants.maxOffsetX { return }
                withAnimation {
                    offsetX = value.translation.width
                }
            }
            .onEnded { value in
                if -value.translation.width > Constants.maxOffsetX {
                    withAnimation {
                        offsetX = -Constants.maxOffsetX
                        showTrash = true
                    }
                }
                if -value.translation.width < 5 {
                    showTrash = false
                    withAnimation {
                        offsetX = .zero
                    }
                }
            }
    }
}

// MARK: - UI Subviews

private extension TLNotificationCell {
    var mainContainer: some View {
        ZStack {
            if showTrash {
                Button {
                    withAnimation {
                        offsetX = -400
                        showTrash = false
                        guard let notificationID = configuration.notification?.id else {
                            return
                        }
                        deleteHandler?(notificationID)
                    }
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.foreground)
                        .frame(width: 30)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                }
            }

            notificationCellView
                .offset(x: offsetX)
                .simultaneousGesture(swipeGesture)
        }
    }

    var shimmeringView: some View {
        ShimmeringView(kind: .inverted)
    }

    var shimmeringContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    shimmeringView
                        .frame(width: 100, height: 20)
                    shimmeringView
                        .frame(width: 80, height: 12)
                }
                .clipShape(.capsule)
            }
            VStack(alignment: .leading, spacing: 4) {
                shimmeringView
                    .frame(height: 15)
                    .clipShape(.capsule)
                shimmeringView
                    .frame(height: 15)
                    .clipShape(.capsule)
                    .padding(.trailing, 30)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Constants.notificationBgColor, in: .rect(cornerRadius: 16))
    }

    @ViewBuilder
    var notificationCellView: some View {
        if let notification = configuration.notification {
            VStack {
                Text(notification.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))

                Text(notification.date)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12, weight: .medium, design: .serif))

                if let message = notification.text {
                    Text(message)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                }
            }
            .padding()
            .background(Constants.notificationBgColor, in: .rect(cornerRadius: 16))
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        TLNotificationCell(
            configuration: .init(
                notification: .init(
                    id: "-1",
                    title: "Доставка",
                    text: "Вас ожидает доставщик торта по номеру заказа #12342",
                    date: Date().description.toCorrectDate,
                    sellerID: "1",
                    cakeID: "1"
                )
            )
        ) { id in
            print("delete: \(id)")
        }

        TLNotificationCell(
            configuration: .init(isShimmering: true)
        )
    }
    .padding()
    .background(.bar)
}

// MARK: - Constants

private extension TLNotificationCell {
    enum Constants {
        static let topLineColor = LinearGradient(
            colors: [.blue, .blue, .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
        static let notificationBgColor = TLColor<BackgroundPalette>.bgCommentView.color
        static var maxOffsetX: CGFloat = 80
    }
}
