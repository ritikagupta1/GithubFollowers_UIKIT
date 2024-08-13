//
//  FavouriteCell.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 02/08/24.
//

import UIKit

class FavouriteCell: UITableViewCell {
    static let reuseID = "favouriteCell"
    let avatarImageView = GFImageView(frame: .zero)
    let titleLabel = GFTitleLabel(fontSize: 26, alignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.avatarImageView.image = GFImageView.placeHolderImage
        self.titleLabel.text = nil
        super.prepareForReuse()
    }
    
    private func configure() {
        self.contentView.addSubViews(avatarImageView, titleLabel)
        accessoryType = .disclosureIndicator
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func set(with favourite: Follower) {
        NetworkManager.shared.downloadImage(from: favourite.avatarUrl) { [weak self] image in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                if self.titleLabel.text == favourite.login {
                    self.avatarImageView.image = image ?? GFImageView.placeHolderImage
                }
            }
        }
        self.titleLabel.text = favourite.login
    }
}
