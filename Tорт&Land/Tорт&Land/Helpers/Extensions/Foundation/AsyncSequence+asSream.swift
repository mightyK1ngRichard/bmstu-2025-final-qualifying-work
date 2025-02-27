//
//  AsyncSequence+asSream.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation

extension AsyncSequence {
    func asStream() -> AsyncThrowingStream<Self.Element, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    for try await element in self {
                        continuation.yield(element)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
