//
//  ImageDownloader.swift
//  Game In-Depth
//
//  Created by Indra Permana on 12/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class ApiManager {
    private let baseURL = "https://api.rawg.io/api/"
    static let shared = ApiManager()
    
    func fetchPopularGames(completionHandler: @escaping ([Game]?) -> Void) {
        let requestUrl = baseURL + "games"
        var components = URLComponents(string: requestUrl)!
        components.queryItems = [
            URLQueryItem(name: "dates", value: "2020-01-01,2020-12-31"),
            URLQueryItem(name: "ordering", value: "-added"),
            URLQueryItem(name: "page_size", value: "5")
            
        ]
        
        let request = URLRequest(url: components.url!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            if error != nil {
                print("error fetching image")
                completionHandler(nil)
            } else if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let fetchedGames = try decoder.decode(Games.self, from: data)
                    
                    completionHandler(fetchedGames.results)
                    
                } catch  {
                    print(error.localizedDescription)
                }
                
                
            }
        }
        dataTask.resume()
    }
    
    func fetchImagePoster(game: Game, completionHandler: @escaping (Data?) -> Void) {
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: game.backgroundImage) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            if error != nil {
                print("error fetching image")
                completionHandler(nil)
            } else if response.statusCode == 200 {
                completionHandler(data)
            }
        }
        dataTask.resume()
    }
}
