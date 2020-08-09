//
//  Game.swift
//  Game In-Depth
//
//  Created by Indra Permana on 12/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

struct Games: Codable {
    let count: Int
    let results: [Game]?
}

struct Game: Codable {
    let gameId: Int
    let name: String
    let backgroundImage: URL?
    let metacritic: String?
    let rating: Float?
    let released: String?
    var imageDownloadstate: ImageDownloadStates
    var backgroundImageDownloaded: UIImage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let backgroundImageString = try container.decodeIfPresent(String.self, forKey: .backgroundImage) ?? ""
        
        gameId = try container.decode(Int.self, forKey: .gameId)
        name = try container.decode(String.self, forKey: .name)
        backgroundImage = URL(string: backgroundImageString)
        // Use decodeIfPresent to prevent null error
        let metacriticScore = try container.decodeIfPresent(Int.self, forKey: .metacritic) ?? 0
        if metacriticScore == 0 {
            metacritic = "Not Available"
        } else {
            metacritic = metacriticScore.description
        }
        released = try container.decodeIfPresent(String.self, forKey: .released) ?? "-"
        rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0
        backgroundImageDownloaded = UIImage()
        imageDownloadstate = .new
    }

    enum CodingKeys: String, CodingKey {
        case name, metacritic, released, rating
        case backgroundImage = "background_image"
        case gameId = "id"
    }
}

enum ImageDownloadStates {
    case new, downloaded, failed
}

enum HomeCollectionViewTag: Int {
    case mainBanner = 0
    case upcommingBanner = 1
    case topBanner = 2
}

enum ListGameTypes {
    case upcoming
    case topRated
}
