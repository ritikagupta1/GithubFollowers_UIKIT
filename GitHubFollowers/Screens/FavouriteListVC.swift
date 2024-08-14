//
//  FollowerVC.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 16/07/24.
//

import UIKit

class FavouriteListVC: GFDataLoadingVC {
    let tableView = UITableView()
    var favourites: [Follower] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getFavourites()
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.title = "Favourites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let favourites):
                if favourites.isEmpty {
                    self.showEmptyStateView(with: "No Favourites? \n Add one on the follower screen.")
                } else {
                    self.favourites = favourites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlertViewController(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func configureTableView() {
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80.0
        tableView.removeExcessCells()
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }

}

extension FavouriteListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID, for: indexPath) as? FavouriteCell else {
            return UITableViewCell()
        }
        
        cell.set(with: favourites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = self.favourites[indexPath.row]
        
        let destVC = FollowersListVC(userName: favourite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
       
        PersistenceManager.updateFavourites(with: self.favourites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else {
                return
            }
            guard let error else {
                self.favourites.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    if self.favourites.isEmpty {
                        self.showEmptyStateView(with: "No Favourites? \n Add one on the follower screen.")
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlertViewController(title: "Unable to remove the favourited user", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }
}
