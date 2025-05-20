//
//  Networkable.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 19.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftData

protocol Networkable {
    associatedtype NetworkEntity: Sendable

    init(from model: NetworkEntity)
}
