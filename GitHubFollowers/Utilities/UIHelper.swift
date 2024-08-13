//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 25/07/24.
//

import UIKit

enum UIHelper {
    static func createCollectionViewFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        let minimumSpacing: CGFloat = 8
        
        let totalWidth = view.bounds.width
        let availableWidth = totalWidth - (2 * minimumSpacing) - (2 * padding)
        let itemWidth = availableWidth / 3
        
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
