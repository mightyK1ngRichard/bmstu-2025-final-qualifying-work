//
//  CategoriesModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 13.05.2025.
//

import Foundation

enum CategoriesModel {}

extension CategoriesModel {

    struct BindingData: Hashable {
        var selectedImageData: Data?
        var isShowingSheet = false
        var alert = AlertModel()
        var createFillingModel = CreateFillingModel()
        var createCategoryModel = CreateCategoryModel()
        var sheetKind: SheetKind = .addCategory

        var saveNewFillButtonIsDisable: Bool {
            createFillingModel.buttonIsDisable || selectedImageData == nil
        }
        var saveNewCategoryButtonIsDisable: Bool {
            createCategoryModel.buttonIsDisable || selectedImageData == nil
        }
    }

    struct CreateCategoryModel: Hashable {
        var inputName = ""
        var selectedGenderTags: [Category.Gender] = []
        var inputError: String?

        var buttonIsDisable: Bool {
            inputName.isEmpty || selectedGenderTags.isEmpty
        }

        mutating func reset() {
            inputName.removeAll()
            selectedGenderTags.removeAll()
            inputError = nil
        }
    }

    struct CreateFillingModel: Hashable {
        var inputName = ""
        var inputContent = ""
        var inputKgPrice = ""
        var inputDescription = ""
        var inputError: String?

        var buttonIsDisable: Bool {
            inputName.isEmpty || inputContent.isEmpty || inputKgPrice.isEmpty || inputDescription.isEmpty
        }

        mutating func reset() {
            inputName.removeAll()
            inputContent.removeAll()
            inputKgPrice.removeAll()
            inputDescription.removeAll()
            inputError = nil
        }
    }

    enum SheetKind: Hashable {
        case addCategory
        case addFilling
    }

}
