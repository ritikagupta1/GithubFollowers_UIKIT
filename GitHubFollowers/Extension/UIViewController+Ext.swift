//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 16/07/24.
//

import UIKit

extension UIViewController {
    func presentGFAlertViewController(title: String, message: String, buttonTitle: String) {
//        DispatchQueue.main.async { // with new async await we don't need to do the main thread handling
            let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
            
//        }
    }
    
    func presentDefaultAlertVC() {
            let alertVC = GFAlertViewController(
                title: "Something went wrong",
                message: "Please try again later",
                buttonTitle: "Ok")
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
    }
}
