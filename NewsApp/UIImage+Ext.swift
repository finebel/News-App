//
//  UIImage+Ext.swift
//  NewsApp
//
//  Created by finebel on 04.03.21.
//

import UIKit

extension UIImage {
    private static func createUIImage(systemName: String) -> UIImage? {
        UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 21, weight: .semibold))
    }
    
    static let systemEmptyStar = createUIImage(systemName: "star")
    
    static let systemFillStar = createUIImage(systemName: "star.fill")

    static let systemArrowUp = createUIImage(systemName: "arrow.up")

    static let systemArrowDown = createUIImage(systemName: "arrow.down")
}
