//
//  ImageDownloader.swift
//  Game In-Depth
//
//  Created by Indra Permana on 12/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class ApiManager {
    fileprivate let baseURL = "https://api.rawg.io"
    static let shared = ApiManager()
    
    func fetchPopularGames(completionHandler: @escaping ([Game]?) -> Void) {
//        let requestUrl = baseURL + "games"
        var components = URLComponents(string: baseURL)!
        components.path = "/api/games"
        components.queryItems = [
            URLQueryItem(name: "dates", value: "2020-01-01,2020-07-01"),
            URLQueryItem(name: "ordering", value: "-added"),
            URLQueryItem(name: "page_size", value: "5")
            
        ]
        print(components.url?.absoluteString)
        let request = URLRequest(url: components.url!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            if error != nil {
                print("error fetching image")
                completionHandler(nil)
            } else if response.statusCode == 200 {
                let decoder = JSONDecoder()
                print(data.debugDescription)
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
    
    func fetchAnticipatedGames(pageSize: Int, page: Int = 1, completionHandler: @escaping (Games?) -> Void) {
        //        let requestUrl = baseURL + "games"
        var components = URLComponents(string: baseURL)!
        components.path = "/api/games"
        components.queryItems = [
            URLQueryItem(name: "dates", value: "2020-07-01,2021-12-31"),
            URLQueryItem(name: "ordering", value: "-added"),
            URLQueryItem(name: "page_size", value: pageSize.description),
            URLQueryItem(name: "page", value: page.description)
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
                    
                    completionHandler(fetchedGames)
                    
                } catch  {
                    print(error.localizedDescription)
                }
                
                
            }
        }
        dataTask.resume()
    }
    
    func fetchHighestRatedGames(pageSize: Int, page: Int = 1, completionHandler: @escaping (Games?) -> Void) {
        //        let requestUrl = baseURL + "games"
        var components = URLComponents(string: baseURL)!
        components.path = "/api/games"
        components.queryItems = [
            URLQueryItem(name: "ordering", value: "--rating"),
            URLQueryItem(name: "page_size", value: pageSize.description),
            URLQueryItem(name: "page", value: page.description)
            
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
                    
                    completionHandler(fetchedGames)
                    
                } catch  {
                    print(error.localizedDescription)
                }
                
                
            }
        }
        dataTask.resume()
    }
    
    func fetchImagePoster(imageURL: URL, completionHandler: @escaping (Data?) -> Void) {
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: imageURL) { (data, response, error) in
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
    
    
    func fetchDetailGames(id: Int, completionHandler: @escaping (GameDetail?) -> Void) {
//        let requestUrl = baseURL + "games/\(id)"
        var components = URLComponents(string: baseURL)!
        components.path = "/api/games/\(String(id))"
//        components.path = String(id)
//        components.queryItems = [
//            URLQueryItem(name: "dates", value: "2020-01-01,2020-07-01"),
//            URLQueryItem(name: "ordering", value: "-added"),
//            URLQueryItem(name: "page_size", value: "5")
//
//        ]
        print(components.url?.absoluteString)
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
                    let fetchedGame = try decoder.decode(GameDetail.self, from: data)
                    
                    completionHandler(fetchedGame)
                    
                } catch  {
                    print(error.localizedDescription)
                }
                
                
            }
        }
        dataTask.resume()
    }
    
    func fetchSearchGames(stop:Bool = false,query: String, pageSize: Int, page: Int = 1, completionHandler: @escaping (Games?) -> Void) {
    //        let requestUrl = baseURL + "games/\(id)"
            var components = URLComponents(string: baseURL)!
            components.path = "/api/games"
            components.queryItems = [
                URLQueryItem(name: "search", value: query),
    //            URLQueryItem(name: "ordering", value: "-added"),
    //            URLQueryItem(name: "page_size", value: "5")
    //
            ]
            
            let request = URLRequest(url: components.url!)
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                guard let response = response as? HTTPURLResponse, let data = data else { return }
                if error != nil {
                    print("error searched games")
                    completionHandler(nil)
                } else if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let fetchedGames = try decoder.decode(Games.self, from: data)
                        
                        completionHandler(fetchedGames)
                        
                    } catch  {
                        print(error.localizedDescription)
                    }
                    
                    
                }
            }
        if !stop {
            dataTask.resume()
        } else {
            dataTask.cancel()
        }
    }
}
