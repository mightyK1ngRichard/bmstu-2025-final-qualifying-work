//
//  Thumbnail.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//

import Foundation

struct Thumbnail: Identifiable, Hashable {
    var id: String { UUID().uuidString }
    var imageState: ImageState
    var url: String?
}
