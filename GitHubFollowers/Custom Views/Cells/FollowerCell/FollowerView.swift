//
//  FollowerView.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 14/08/24.
//

import SwiftUI

struct FollowerView: View {
    let follower: Follower
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(uiImage: .avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }.clipShape(.circle)
            
            Text(follower.login)
                .bold()
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
    }
}

#Preview {
    FollowerView(follower: Follower(login: "sallen0400", avatarUrl: ""))
}
