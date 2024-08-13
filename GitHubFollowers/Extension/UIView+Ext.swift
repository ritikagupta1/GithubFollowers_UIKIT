//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 07/08/24.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
