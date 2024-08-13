//
//  GFImageView.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 18/07/24.
//

import UIKit

class GFImageView: UIImageView {
    static let placeHolderImage: UIImage = .avatarPlaceholder
    let cache = NetworkManager.shared.imageCache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        self.image = GFImageView.placeHolderImage
    }
}
