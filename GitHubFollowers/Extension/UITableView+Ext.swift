//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 09/08/24.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        let footerView = UIView(frame: .zero)
        self.tableFooterView = footerView
    }
}
