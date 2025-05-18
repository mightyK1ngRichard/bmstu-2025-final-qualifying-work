//
//  StringConstants.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum StringConstants {
    static let anonimeUserName = String(localized: "Anonymous")
    static let rub = "₽"
    static let invalidInputData = String(localized: "Invalid input data")
    static let currentUserNotFound = String(localized: "Current user not found")
    static let currentUserNotFoundSubtitle = String(localized: "Current user not found. Please try again later.")
    static let innerError = String(localized: "Inner error. Relaunch this app")
    static let sessionExpiredTitle = String(localized: "Session Expired")
    static let sessionExpiredSubtitle = String(localized: "Your session has expired. Please log in again to continue.")
    static let formFieldsMissingError = String(localized: "Please make sure all fields are filled: cake, filling, address, and total amount.")
    static let modelErrorTitle = String(localized: "Model Error")
    static let modelErrorSubtitle = String(localized: "The 3D model URL is missing or incorrectly formatted.")
    static let chooseRating = String(localized: "choose rating")
    static let textCannotBeEmpty = String(localized: "Text cannot be empty")
    static let failedFetch3DModel = String(localized: "Failed to fetch 3D model")
    static let fillInAllFields = String(localized: "Fill in all the fields")
    static let passwordDoesNotMatch = String(localized: "Password does not match")
    static let invalidInputPrice = String(localized: "invalid input price")
    static let cakeIsClosedForSale = String(localized: "Sorry, this item is currently closed for sale")
    static let tryAgain = String(localized: "Try again")
    static let logout = String(localized: "Logout")
    static let save = String(localized: "save")
}
