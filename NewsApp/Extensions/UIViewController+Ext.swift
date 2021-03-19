//
//  UIViewController+Ext.swift
//  NewsApp
//
//  Created by finebel on 12.08.20.
//

import UIKit

extension UIViewController {
    func presentWarningAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
