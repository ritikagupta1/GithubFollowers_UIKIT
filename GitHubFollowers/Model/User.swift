//
//  User.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 17/07/24.
//

import Foundation
struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
   
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    
    let followers: Int
    let following: Int
    
    let createdAt: String
}
