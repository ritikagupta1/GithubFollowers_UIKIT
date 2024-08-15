//
//  FavouriteView.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 14/08/24.
//

import SwiftUI

struct FavouriteView: View {
    var favourite: Follower
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: favourite.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(uiImage: .avatarPlaceholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .clipShape(.circle)
                
            Text(favourite.login)
                .bold()
                .font(.title2)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .padding(.trailing, 80)
        }
    }
}

#Preview {
    FavouriteView(favourite: Follower(login: "twostraws", avatarUrl: ""))
}
