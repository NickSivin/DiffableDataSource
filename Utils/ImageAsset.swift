//
//  ImageAsset.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

struct ImageAsset {
    enum ImageName: String {
        case pagination
        case dragAndDrop
        
        var key: String {
            return rawValue
                .splitByUppercasedWords()
                .joined(separator: "_")
        }
    }
    
    static func image(named name: ImageName?) -> UIImage? {
        guard let name = name else { return nil }
        return UIImage(named: name.key)
    }
}


