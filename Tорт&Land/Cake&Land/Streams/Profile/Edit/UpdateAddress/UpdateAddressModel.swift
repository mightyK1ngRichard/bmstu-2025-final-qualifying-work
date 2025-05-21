//
//  UpdateAddressModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

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
        var isLoading = false
        var buttonIsLoading = false
        var alert = AlertModel()
    }
}
