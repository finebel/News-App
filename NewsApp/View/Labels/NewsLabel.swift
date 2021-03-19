//
//  NewsLabel.swift
//  NewsApp
//
//  Created by finebel on 11.08.20.
//

import UIKit

///Label, which can be initialized with a custom `fontStyle`, `numberOfLines` and `textAlignment`.
class NewsLabel: UILabel {
    
    init(fontStyle: UIFont.TextStyle, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .natural) {
        super.init(frame: .zero)
        
        self.font = UIFont.preferredFont(forTextStyle: fontStyle)
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
