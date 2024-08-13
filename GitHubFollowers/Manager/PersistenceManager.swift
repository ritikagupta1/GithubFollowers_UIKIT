//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 02/08/24.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Key {
        static let favourites = "favourites"
    }
    
    enum PersistenceActionType {
        case add
        case remove
    }
    
    static func retrieveFavourites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favouritesData = defaults.object(forKey:  Key.favourites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(.unableToFavourites))
        }
    }
    
    static func saveFavourites(favourites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let favouritesData = try encoder.encode(favourites)
            defaults.setValue(favouritesData, forKey: Key.favourites)
            return nil
        } catch {
            return .unableToFavourites
        }
    }
    
    static func updateFavourites(with favourite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
       self.retrieveFavourites { result in
            switch result {
            case .success(var retrievedFavourites):
                switch actionType {
                case .add:
                    guard !retrievedFavourites.contains(favourite) else {
                        completion(.alreadyAddedToFavourites)
                        return
                    }
                    
                    retrievedFavourites.append(favourite)
                
                case .remove:
                    retrievedFavourites.removeAll { $0 == favourite }
                }
                
                completion(self.saveFavourites(favourites: retrievedFavourites))
            case .failure(let error):
                completion(error)
            }
        }
    }
}
