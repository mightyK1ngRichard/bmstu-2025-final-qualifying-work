//
//  UpdateAddressView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

enum UpdateAddressModel {
    struct UIProperties: Hashable {
        /// Подъезд
        var inputEntrance = ""
        /// Этаж
        var inputFloor = ""
        /// Квартира
        var inputApartment = ""
        /// Комментарий к доставке
        var inputComment = ""
    }
}

struct UpdateAddressView: View {
    @State var uiProperties = UpdateAddressModel.UIProperties()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TLInputCode(
                    configuration: .init(
                        title: "Подъезд",
                        placeholder: Constants.entrancePlaceholder
                    ),
                    inputText: $uiProperties.inputEntrance
                )

                TLInputCode(
                    configuration: .init(
                        title: "Этаж",
                        placeholder: Constants.entranceFloorPlaceholder
                    ),
                    inputText: $uiProperties.inputFloor
                )

                TLInputCode(
                    configuration: .init(
                        title: "Квартира",
                        placeholder: Constants.apartmentPlaceholder
                    ),
                    inputText: $uiProperties.inputApartment
                )

                TLInputCode(
                    configuration: .init(
                        title: "Комментарий к доставке",
                        placeholder: Constants.commentPlaceholder
                    ),
                    inputText: $uiProperties.inputComment
                )
            }
            .padding(.horizontal)
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
    }
}

// MARK: - Preview

#Preview {
    UpdateAddressView()
}

private extension UpdateAddressView {

    enum Constants {
        static let entrancePlaceholder = "Номер подъезда"
        static let entranceFloorPlaceholder = "Номер этажа"
        static let apartmentPlaceholder = "Номер этажа"
        static let commentPlaceholder = "Остановитесь возле шлагбаума"
    }
}
