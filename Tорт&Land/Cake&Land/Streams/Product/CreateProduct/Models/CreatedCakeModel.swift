//
//  CreatedCakeModel.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 17.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Core

struct CreatedCakeModel: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let mass: Double
    let previewImageState: ImageState
}
