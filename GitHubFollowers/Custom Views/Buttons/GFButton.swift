//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 16/07/24.
//

import UIKit

class GFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        self.set(color: color, title: title, systemImageName: systemImageName)
    }
    
    private func configure() {
//        self.layer.cornerRadius = 10
//        self.setTitleColor(.white, for: .normal)
       // self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String, systemImageName: String) {
        
        configuration = .tinted()
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.cornerStyle = .medium
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePlacement = .trailing
        configuration?.imagePadding = 6
    }
}

