//
//  GFDataLoadingVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 06/08/24.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0.0
        
        self.view.addSubview(containerView)
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingIndicator() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.containerView.alpha = 0.0
                self.containerView.removeFromSuperview()
                self.containerView = nil
            }
        }
    }
    
    
    func showEmptyStateView(with message: String) {
        let emptyStateView = GFEmptyStateView(emptyText: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
