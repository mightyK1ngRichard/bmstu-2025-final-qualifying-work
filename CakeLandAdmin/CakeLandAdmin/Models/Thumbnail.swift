//
//  Thumbnail.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import MacCore

struct Thumbnail: Identifiable, Hashable {
    var id: String
    var imageState: ImageState
    var url: String
}

extension Thumbnail {
    init(url: String, id: String = UUID().uuidString, imageState: ImageState = .loading) {
        self.id = id
        self.imageState = imageState
        self.url = url
    }
}
