//
//  ImageAsset.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

struct ImageAsset {
    enum ImageName: String {
        case stickyHeader
        
        var key: String {
            return rawValue
                .splitByUppercasedWords()
                .joined(separator: "_")
        }
    }
    
    static func image(named name: ImageName) -> UIImage? {
        return UIImage(named: name.key)
    }
}


