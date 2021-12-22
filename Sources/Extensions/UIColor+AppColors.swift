//
//  UIColor+AppColors.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

extension UIColor {
    static let base1 = colorFrom(red: 186, green: 171, blue: 207)
    static let base2 = colorFrom(red: 225, green: 225, blue: 225)
    
    private static func colorFrom(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
