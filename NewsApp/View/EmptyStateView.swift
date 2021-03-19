//
//  EmptyStateView.swift
//  NewsApp
//
//  Created by finebel on 26.08.20.
//

import UIKit

///This class can be used to display a view which shows an image and a text label. The image and text can be set due to initialization process.
class EmptyStateView: UIView {
    
    private let emptyStateViewImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        iv.alpha = 0.45
        return iv
    }()
    
    private let textToDisplay = NewsLabel(fontStyle: .headline, numberOfLines: 0, textAlignment: .center)

    init(imageSystemName: String, text: String) {
        super.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular, scale: .large)
        emptyStateViewImage.image = UIImage(systemName: imageSystemName, withConfiguration: config)
        textToDisplay.text = text
        textToDisplay.alpha = 0.45
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(views: [emptyStateViewImage, textToDisplay])
        
        NSLayoutConstraint.activate([
            emptyStateViewImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            emptyStateViewImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateViewImage.widthAnchor.constraint(equalToConstant: 120),
            emptyStateViewImage.heightAnchor.constraint(equalToConstant: 120),
            
            textToDisplay.topAnchor.constraint(equalTo: emptyStateViewImage.bottomAnchor, constant: 5),
            textToDisplay.centerXAnchor.constraint(equalTo: centerXAnchor),
            textToDisplay.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            textToDisplay.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
}
