//
//  GFFollowersInfoVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 01/08/24.
//

import UIKit
protocol GFFollowersInfoVCDelegate: AnyObject {
    func didTapGetFollowers(user: User)
}

class GFFollowersInfoVC: GFItemInfoViewController {
    weak var delegate: GFFollowersInfoVCDelegate!
    
    init(user: User, delegate: GFFollowersInfoVCDelegate) {
        self.delegate = delegate
        super.init(user: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        button.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
    }
    
    override func buttonActionTapped() {
        delegate?.didTapGetFollowers(user: self.user)
    }
}
