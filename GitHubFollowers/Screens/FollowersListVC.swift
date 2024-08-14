//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 16/07/24.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {
    enum Section {
        case main
    }
    
    var userName: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var page: Int = 1
    var hasMoreFollowers = true
    var isLoadingFollowers = false
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setUpCollectionView()
        configureSearchController()
        getFollowers(page: self.page)
        setUpDataSource()
    }
    
    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        self.title = userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let plusButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavourite))
        navigationItem.rightBarButtonItem = plusButtonItem
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter a username"
        //searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
//        searchController.obscuresBackgroundDuringPresentation = true // default is false for ios 15+
    }
    
    @objc func addFavourite() {
        showLoadingView()
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: userName)
                self.dismissLoadingIndicator()
                PersistenceManager.updateFavourites(
                    with: Follower(login: user.login, avatarUrl: user.avatarUrl),
                    actionType: .add) { [weak self] error in
                        guard let self else {
                            return
                        }
                        
                        if let error {
//                            DispatchQueue.main.async {
                                self.presentGFAlertViewController(
                                    title: "Something went wrong",
                                    message: error.rawValue,
                                    buttonTitle: "Ok")
//                            }
                        } else {
//                            DispatchQueue.main.async {
                                self.presentGFAlertViewController(
                                    title: "Success",
                                    message: "You have successfully favourited this user 🎊",
                                    buttonTitle: "Ok")
//                            }
                        }
                    }
            } catch {
                self.dismissLoadingIndicator()
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
        //            self.dismissLoadingIndicator()
        //
        //            switch result {
        //            case .success(let user):
        //                PersistenceManager.updateFavourites(
        //                    with: Follower(login: user.login, avatarUrl: user.avatarUrl),
        //                    actionType: .add) { [weak self] error in
        //                        guard let self = self else {
        //                            return
        //                        }
        //
        //                        if let error = error {
        //                            self.presentGFAlertViewController(
        //                                title: "Something went wrong",
        //                                message: error.rawValue,
        //                                buttonTitle: "Ok")
        //                        } else {
        //                            self.presentGFAlertViewController(
        //                                title: "Success",
        //                                message: "You have successfully favourited this user 🎊",
        //                                buttonTitle: "Ok")
        //                        }
        //                    }
        //
        //            case .failure(let error):
        //                self.presentGFAlertViewController(
        //                    title: "Something went wrong",
        //                    message: error.rawValue,
        //                    buttonTitle: "Ok")
        //            }
        //        }
    }
    
    func setUpCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCollectionViewFlowLayout(in: self.view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
    }
    
    func getFollowers(page: Int) {
        self.showLoadingView()
        self.isLoadingFollowers = true
        print("1")
        Task {
            do {
                print("2")
                let followers = try await NetworkManager.shared.getFollowers(for: userName, page: page)
                print("3")
                self.dismissLoadingIndicator()
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    DispatchQueue.main.async {
                        self.followers.removeAll()
                        self.updateData(with: self.followers)
                        self.showEmptyStateView(with: "This user doesn't have any followers. Go Follow them 😄.")
                    }
                } else {
                    if filteredFollowers.isEmpty {
                        self.updateData(with: self.followers)
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.filteredFollowers = self.followers.filter{ $0.login.lowercased().contains(self.navigationItem.searchController?.searchBar.text?.lowercased() ?? "")}
                            self.updateData(with: self.filteredFollowers)
                        }
                    }
                    
                }
            } catch {
                self.dismissLoadingIndicator()
                if let gfError = error as? GFError {
                    self.presentGFAlertViewController(
                        title: "Something went wrong",
                        message: gfError.rawValue,
                        buttonTitle: "Ok")
                } else {
                    self.presentDefaultAlertVC()
                }
            }
            print("4")
            self.isLoadingFollowers = false
        }
        print("8")
//        NetworkManager.shared.getFollowers(for: userName, page: page, completion: { [weak self] result in
//            guard let self = self else {
//                return
//            }
//            
//            self.dismissLoadingIndicator()
//           
//            switch result {
//            case let .success(followers):
//                if followers.count < 100 {
//                    self.hasMoreFollowers = false
//                }
//                self.followers.append(contentsOf: followers)
//                if self.followers.isEmpty {
//                    DispatchQueue.main.async {
//                        self.followers.removeAll()
//                        self.updateData(with: self.followers)
//                        self.showEmptyStateView(with: "This user doesn't have any followers. Go Follow them 😄.")
//                    }
//                } else {
//                    if filteredFollowers.isEmpty {
//                        self.updateData(with: self.followers)
//                    } else {
//                        DispatchQueue.main.async { [weak self] in
//                            guard let self = self else { return }
//                            self.filteredFollowers = self.followers.filter{ $0.login.lowercased().contains(self.navigationItem.searchController?.searchBar.text?.lowercased() ?? "")}
//                            self.updateData(with: self.filteredFollowers)
//                        }
//                    }
//                   
//                }
//                
//            case .failure(let error):
//                self.presentGFAlertViewController(
//                    title: "Bad Stuff happened",
//                    message: error.rawValue,
//                    buttonTitle: "Ok")
//            }
//            self.isLoadingFollowers = false
//        })
    }
    
    deinit {
        print("FollowerListVC is deinitialised")
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower  in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
            cell.setup(follower: follower)
            return cell
        })
    }
    
    func updateData(with followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapShot, animatingDifferences: true) }
    }

}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
//        print("****************")
//        print("OffSetY -- \(offSetY)")
//        print("contentHeight -- \(contentHeight)")
//        print("height -- \(height)")
//        print("****************")
        if offSetY > contentHeight - height, hasMoreFollowers, !isLoadingFollowers {
            print("page \(page)")
            self.page += 1
            getFollowers(page: self.page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFollower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        let userInfoVC = UserInfoVC(username: selectedFollower.login)
        userInfoVC.delegate = self
        let navigationController = UINavigationController(rootViewController: userInfoVC)
        self.present(navigationController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isSearching = false
            filteredFollowers.removeAll()
            updateData(with: self.followers)
            return
        }
        
        isSearching = true
        
        filteredFollowers = followers.filter{  $0.login.lowercased().contains(searchText.lowercased())}
        updateData(with: filteredFollowers)
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearching = false
//        updateData(with: self.followers)
//    }
}

extension FollowersListVC: UserInfoVCDelegate {
    func didTapGetFollowers(username: String) {
        self.userName = username
        self.title = username
        self.page = 1
        self.followers.removeAll()
        self.hasMoreFollowers = true
        self.isLoadingFollowers = false
        //self.filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        self.getFollowers(page: page)
    }
}
