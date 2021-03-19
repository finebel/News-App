//
//  NewsButton.swift
//  NewsApp
//
//  Created by finebel on 13.08.20.
//

import UIKit

///A rounded Button which can be customized during initialization by setting a `backgroundColor` and a `title`
class NewsButton: UIButton {
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 12
    }
}
