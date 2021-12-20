//
//  String+Split.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

extension String {
    func splitByUppercasedWords() -> [String] {
        var result: [String] = []
        var string: String = ""
        
        var iterator = makeIterator()
        
        while let character = iterator.next() {
            if character.isUppercase, !string.isEmpty {
                result.append(string)
                string = String(character.lowercased())
            } else {
                string.append(character)
            }
        }
        
        result.appendNonEmpty(string)
        return result
    }
}

private extension Array where Element == String {
    mutating func appendNonEmpty(_ element: String) {
        guard !element.isEmpty else { return }
        self = self + [element]
    }
}
