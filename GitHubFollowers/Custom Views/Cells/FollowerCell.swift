//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 18/07/24.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseIdentifier = "followerCell"
    let imageView =  GFImageView(frame: .zero)
    let titleLabel = GFTitleLabel(fontSize: 16, alignment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func prepareForReuse() {
        self.imageView.image = GFImageView.placeHolderImage
        self.titleLabel.text = nil
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(follower: Follower) {
        self.titleLabel.text = follower.login
        
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if self.titleLabel.text == follower.login {
                    self.imageView.image = image ?? GFImageView.placeHolderImage
                }
            }
        }
    }
    
    private func configure() {
        self.contentView.addSubViews(imageView, titleLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
