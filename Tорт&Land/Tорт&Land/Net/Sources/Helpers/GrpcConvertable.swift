//
//  GrpcConvertable.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation

protocol GrpcConvertable {
    associatedtype GRPCModel: Sendable

    init(from model: GRPCModel)
}
