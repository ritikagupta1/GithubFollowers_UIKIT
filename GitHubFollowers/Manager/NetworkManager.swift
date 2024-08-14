//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 17/07/24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    private let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for userName: String, page: Int) async throws -> [Follower] {
        // Create the endPoint from the baseURL String
        let endPoint: String = baseURL + "\(userName)/followers?per_page=100&page=\(page)"
        
        let followers: [Follower] = try await getData(for: endPoint)
        return followers
    }
    
    func getUserInfo(for username: String) async throws -> User {
        let urlString = baseURL + "\(username)"
        
        let user: User = try await getData(for: urlString)
        return user
    }
    
//    func getData<T: Codable>(for endPoint: String, completion: @escaping (Result<T,GFError>) -> Void) {
//        // Create the endPoint from the baseURL String
//        // Check if endpoint can be transformed in to URL
//        
//        
//        guard let url = URL(string: endPoint) else {
//            completion(.failure(.invalidUserName))
//            return
//        }
//        
//        let request = URLRequest(url: url)
////        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // Check if there is any error
//            if let _ = error {
//                completion(.failure(.unableToCompleteRequest))
//                return
//            }
//            
//            // check if response is of type HTTPURLResponse and status code is 200 for get request
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//            
//            // Check if data exists
//            guard let data = data else {
//                completion(.failure(.invalidData))
//                return
//            }
//            //Decode the data
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let model = try decoder.decode(T.self, from: data)
//                completion(.success(model))
//            } catch {
//                completion(.failure(.invalidData))
//            }
//            
//        }
//        
//        task.resume()
//        
//    }
    
    func getData<T: Codable>(for endPoint: String) async throws -> T {
        // Check if endpoint can be transformed in to URL
        guard let url = URL(string: endPoint) else {
            throw GFError.invalidUserName
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // check if response is of type HTTPURLResponse and status code is 200 for get request
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        //Decode the data
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw GFError.invalidData
        }
        
    }
    
//    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
//        let cacheKey = NSString(string: urlString)
//        if let image = imageCache.object(forKey: cacheKey)  {
//            completion(image)
//            return
//        }
//        
//        
//        guard let url = URL(string: urlString) else {
//            completion(nil)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            
//            guard let self = self, error == nil,
//                  let response = response as? HTTPURLResponse, response.statusCode == 200,
//                  let data = data,
//                  let image = UIImage(data: data) else {
//                completion(nil)
//                return
//            }
//            
//            
//            self.imageCache.setObject(image, forKey: NSString(string: urlString))
//            
//            completion(image)
//        }
//        
//        task.resume()
//    }
    
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = imageCache.object(forKey: cacheKey)  {
            return image
        }
        
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            self.imageCache.setObject(image, forKey: NSString(string: urlString))
            return image
        } catch {
            return nil
        }
       
    }
}
