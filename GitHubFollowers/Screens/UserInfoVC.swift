//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 30/07/24.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didTapGetFollowers(username: String)
}

class UserInfoVC: UIViewController {
    let userName: String
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(alignment: .center)
    
    weak var delegate: UserInfoVCDelegate?
    
//    let containerViews: [UIView] = [headerView, itemViewOne, itemViewTwo] can't provide a default value for a stored property that depends on another instance property.
    init(username: String) {
        self.userName = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: userName)
                self.configureUIElements(with: user)
            } catch {
                if let gfError = error as? GFError {
                    self.presentGFAlertViewController(
                        title: "Something went wrong",
                        message: gfError.rawValue,
                        buttonTitle: "Ok")
                } else {
                    self.presentDefaultAlertVC()
                }
            }
        }
        
        //        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
        //            guard let self = self else {
        //                return
        //            }
        //
        //            switch result {
        //            case .success(let user):
        //
        //                DispatchQueue.main.async {
        //                    self.configureUIElements(with: user)
        //                }
        //
        //            case .failure(let error):
        //                self.presentGFAlertViewController(
        //                    title: "Something went wrong",
        //                    message: error.rawValue,
        //                    buttonTitle: "Ok")
        //            }
        //        }
    }
    
    func configureUIElements(with user: User) {
        let userInfoHeaderVC = GFUserInfoHeaderVC(user: user)
        self.add(childVC: userInfoHeaderVC, to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowersInfoVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        
        let containerViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        containerViews.forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: padding),
                $0.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -padding)
            ])
        }
 
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            headerView.widthAnchor.constraint(equalToConstant: 400),

            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
        
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        // basic code to add a childVC to a VC
//        self.addChild(childVC)
//        view.addSubview(childVC.view)
//        childVC.didMove(toParent: self)
//        childVC.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            childVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            childVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            childVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            childVC.view.heightAnchor.constraint(equalToConstant: 200)
//        ])
        
        self.addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
}

extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGithubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            self.presentGFAlertViewController(
                title: "Invalid URL",
                message: "The url attached to the user is invalid",
                buttonTitle: "Ok")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}

extension UserInfoVC: GFFollowersInfoVCDelegate {
    func didTapGetFollowers(user: User) {
        delegate?.didTapGetFollowers(username: user.login)
        self.dismiss(animated: true)
    }
}
