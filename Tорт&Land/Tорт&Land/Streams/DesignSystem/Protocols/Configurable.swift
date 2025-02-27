//
//  Configurable.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

protocol Configurable {
    associatedtype Configuration: Hashable
    var configuration: Configuration { get }
}
