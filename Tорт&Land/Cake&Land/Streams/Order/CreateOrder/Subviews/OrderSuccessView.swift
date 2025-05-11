//
//  OrderSuccessView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

struct OrderSuccessView: View {
    var action: TLVoidBlock?

    var body: some View {
        VStack(spacing: 49) {
            Image(.bags)
            VStack(spacing: 12) {
                Text("Success!")
//                    .styleDS(34, .bold)

                Text("Your order will be delivered soon.\nThank you for choosing our app!")
//                    .styleDS(14, .regular)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .overlay(alignment: .bottom) {
            TLButton("CONTINUE SHOPPING", action: action)
                .padding()
        }
    }
}

#Preview {
    OrderSuccessView()
}
