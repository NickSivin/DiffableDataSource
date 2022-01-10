//
//  CommonTableViewDataPreparation.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

typealias CommonTableViewDataPreparationOptions = [CommonTableViewDataPreparationOption]

enum CommonTableViewDataPreparationOption {
    case duplicates(CommonTableViewDataPreparationDuplicatesOption)
}

enum CommonTableViewDataPreparationDuplicatesOption {
    case all
    case first
    case last
}

private struct CommonTableViewDataPreparationConfig {
    var duplicatesOption: CommonTableViewDataPreparationDuplicatesOption = .all
    
    init(options: CommonTableViewDataPreparationOptions) {
        options.forEach {
            switch $0 {
            case let .duplicates(duplicatesOption):
                self.duplicatesOption = duplicatesOption
            }
        }
    }
}

class CommonTableViewDataPreparation {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    
    func prepareData(sections: [Section], options: CommonTableViewDataPreparationOptions = []) -> [Section] {
        let config = CommonTableViewDataPreparationConfig(options: options)
        var mutableSectioins = sections
        mutableSectioins = prepareData(sections: sections, duplicatesOption: config.duplicatesOption)
        return mutableSectioins
    }
    
    func prepareData(items: [Item], options: CommonTableViewDataPreparationOptions = []) -> [Item] {
        let result = prepareData(sections: [SingleSection(diffableDataItems: items)], options: options)
        return result.first?.diffableDataItems ?? []
    }
    
    private func prepareData(sections: [Section], duplicatesOption: CommonTableViewDataPreparationDuplicatesOption) -> [Section] {
        guard duplicatesOption != .all else { return sections }
        var duplicatesChecking = getDuplicatesChecking(sections: sections)
        let actualSections = duplicatesOption == .last ? sections.reversed() : sections
        actualSections.forEach { removeDuplicates(in: $0, duplicatesOption: duplicatesOption, duplicatesChecking: &duplicatesChecking) }
        return duplicatesOption == .last ? actualSections.reversed() : actualSections
    }
    
    private func removeDuplicates(in section: Section,
                                  duplicatesOption: CommonTableViewDataPreparationDuplicatesOption,
                                  duplicatesChecking: inout [String: Bool]) {
        var items = duplicatesOption == .last ? section.diffableDataItems.reversed() : section.diffableDataItems
        var deleteUUIDs: [UUID?] = []
        items.forEach {
            guard duplicatesChecking.keys.contains($0.identifier) else { return }
            if duplicatesChecking[$0.identifier] == true {
                deleteUUIDs.append($0.tableIdentifier)
            } else {
                duplicatesChecking[$0.identifier] = true
            }
        }
        items = items.filter { !deleteUUIDs.contains($0.tableIdentifier) }
        section.diffableDataItems = duplicatesOption == .last ? items.reversed() : items
    }
    
    private func getDuplicatesChecking(sections: [Section]) -> [String: Bool] {
        let keys = getIdentifiersOfDuplicates(sections: sections)
        let values = Array(repeating: false, count: keys.count)
        let keysWithValues = zip(keys, values)
        return Dictionary(uniqueKeysWithValues: keysWithValues)
    }
    
    private func getIdentifiersOfDuplicates(sections: [Section]) -> [String] {
        let identifiers = sections.reduce([]) { $0 + $1.diffableDataItems.map { $0.identifier } }
        var buffer = Set<String>()
        var result = Set<String>()
        
        for identifier in identifiers where !buffer.insert(identifier).inserted {
            result.insert(identifier)
        }
        
        return Array(result)
    }
}

private class SingleSection: DiffableDataSection {
    var diffableDataItems: [DiffableDataItem]
    
    init(diffableDataItems: [DiffableDataItem]) {
        self.diffableDataItems = diffableDataItems
    }
}
