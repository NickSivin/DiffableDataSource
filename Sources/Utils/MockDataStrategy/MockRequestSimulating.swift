//
//  MockRequestSimulating.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import CoreGraphics

protocol MockRequestSimulating {
    func simulateRequest(delay: CGFloat, completion: @escaping () -> Void)
}

extension MockRequestSimulating {
    func simulateRequest(delay: CGFloat = 2.0, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
    }
}
