//
//  Localized.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

// MARK: - Common Protocols

protocol LocalizedStrings {
    associatedtype KeyType: LocalizedKeyConvertable
    var tableName: String? { get }
    func string(forKey key: KeyType) -> String
}

extension LocalizedStrings {
    var tableName: String? {
        return nil
    }
    
    func string(forKey key: KeyType) -> String {
        return NSLocalizedString(key.value, tableName: tableName, comment: "")
    }
}

protocol LocalizedKeyConvertable {
    var value: String { get }
}

extension LocalizedKeyConvertable where Self: RawRepresentable, RawValue == String {
    var value: String {
        return rawValue
            .splitByUppercasedWords()
            .joined(separator: ".")
    }
}

// MARK: - Strings File List

struct Localized {
    static var exampleList: ExampleListStrings {
        return ExampleListStrings()
    }
    
    static var exampleDetails: ExampleDetailsStrings {
        return ExampleDetailsStrings()
    }
}

// MARK: - Specific File Configuration

struct ExampleListStrings: LocalizedStrings {
    typealias KeyType = Keys
    
    enum Keys: String, LocalizedKeyConvertable {
        case title
        case supplementarySectionTitle
        case cellsBehaviourSectionTitle
    }
    
    var tableName: String? {
        return "ExampleList"
    }
}

struct ExampleDetailsStrings: LocalizedStrings {
    typealias KeyType = Keys
    
    enum Keys: String, LocalizedKeyConvertable {
        case horizontalStickyHeaderTitle
        case horizontalStickyHeaderDescription
        case zoomableCellsTitle
        case zoomableCellsDescription
    }
    
    var tableName: String? {
        return "ExampleDetails"
    }
}
