//
//  GFEmptyStateView.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 28/07/24.
//

import UIKit

class GFEmptyStateView: UIView {
    let messageLabel = GFTitleLabel(fontSize: 28, alignment: .center)
    let imageView = GFImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(emptyText: String) {
        self.init(frame: .zero)
        messageLabel.text = emptyText
    }
    
    private func configure() {
        messageLabel.numberOfLines = 3
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .secondaryLabel
        
        self.addSubViews(messageLabel, imageView)
        let messageLabelCenterYConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? -90: -150
        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: messageLabelCenterYConstant)
        
        NSLayoutConstraint.activate([
            messageLabelCenterYConstraint,
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
        ])
    }
}
