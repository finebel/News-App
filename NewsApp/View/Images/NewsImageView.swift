//
//  NewsImageView.swift
//  NewsApp
//
//  Created by finebel on 13.08.20.
//

import UIKit

class NewsImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Use this method to populate `NewsImageView`  with a remote image.
    func setImage(urlToImageString: String?) {
        image = nil
        NetworkManager.shared.downloadImage(from: urlToImageString) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
