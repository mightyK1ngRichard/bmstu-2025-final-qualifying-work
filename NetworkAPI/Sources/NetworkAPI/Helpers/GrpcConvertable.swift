//
//  GrpcConvertable.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol GrpcConvertable {
    associatedtype GRPCModel: Sendable

    init(from model: GRPCModel)
}
