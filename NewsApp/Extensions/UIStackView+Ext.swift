//
//  UIStackView+Ext.swift
//  NewsApp
//
//  Created by finebel on 13.08.20.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { (view) in
            self.addArrangedSubview(view)
        }
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}

