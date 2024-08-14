//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 01/08/24.
//

import UIKit
protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGithubProfile(user: User)
}

class GFRepoItemVC: GFItemInfoViewController {
    weak var delegate: GFRepoItemVCDelegate!
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
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
        button.set(color: .systemPurple, title: "Github Profile", systemImageName: "person")
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
    }
    
    override func buttonActionTapped() {
        delegate?.didTapGithubProfile(user: self.user)
    }
}
