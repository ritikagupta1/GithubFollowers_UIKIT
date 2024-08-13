//
//  GFTextField.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 16/07/24.
//

import UIKit

class GFTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray4.cgColor
        
        self.textColor = .label
        self.tintColor = .label
        textAlignment = .center
        self.font = UIFont.preferredFont(forTextStyle: .title2)
        self.autocorrectionType = .no
        self.adjustsFontSizeToFitWidth = true
        self.minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        
        returnKeyType = .go
        clearButtonMode = .whileEditing
        
        self.placeholder = "Enter a username"
    } 
}
