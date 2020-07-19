//
//  Game.swift
//  Game In-Depth
//
//  Created by Indra Permana on 12/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

struct Games: Codable {
    let results: [Game]
}

struct Game: Codable {
    let id: Int
    let name: String
    let backgroundImage: URL
    let metacritic: String?
    var imageDownloadstate: ImageDownloadStates
    var backgroundImageDownloaded: UIImage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let backgroundImageString = try container.decode(String.self, forKey: .backgroundImage)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        backgroundImage = URL(string: backgroundImageString)!
        // Use decodeIfPresent to prevent null error
        let metacriticScore = try container.decodeIfPresent(Int.self, forKey: .metacritic) ?? 0
        if metacriticScore == 0 {
            metacritic = "Not Available"
        } else {
            metacritic = metacriticScore.description
        }
        backgroundImageDownloaded = UIImage()
        imageDownloadstate = .new
    }

    enum CodingKeys: String, CodingKey {
        case id, name, metacritic
        case backgroundImage = "background_image"
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
