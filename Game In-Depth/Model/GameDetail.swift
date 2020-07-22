//
//  GameDetail.swift
//  Game In-Depth
//
//  Created by Indra Permana on 14/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

struct GameDetail: Codable {
    let id: Int
    let name: String
    let description_raw: String
    let metacritic: String?
    let released: String?
    let backgroundImage: URL
    let developers: [Developer]
    let publishers: [Publisher]
    let genres: [Genre]
//    let clip: Clip
    var backgroundImageDownloaded: UIImage
    var imageDownloadstate: ImageDownloadStates
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description_raw = try container.decode(String.self, forKey: .description_raw)
        
        let backgroundImageString = try container.decode(String.self, forKey: .backgroundImage)
        backgroundImage = URL(string: backgroundImageString)!
        let metacriticScore = try container.decodeIfPresent(Int.self, forKey: .metacritic) ?? 0
        if metacriticScore == 0 {
            metacritic = "Not Available"
        } else {
            metacritic = metacriticScore.description
        }
        released = try container.decode(String.self, forKey: .released)
        developers = try container.decode([Developer].self, forKey: .developers)
        publishers = try container.decode([Publisher].self, forKey: .publishers)
        genres = try container.decode([Genre].self, forKey: .genres)
//        clip = try container.decode(Clip.self, forKey: .clip)
        backgroundImageDownloaded = UIImage()
        imageDownloadstate = .new
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, metacritic, description_raw, released, developers, publishers, genres
        case backgroundImage = "background_image"
    }
}

struct Clip: Codable {
    let clip: String
    let preview: String
}

struct Genre: Codable {
    let id: Int
    let name: String
}
struct Developer: Codable {
    let id: Int
    let name: String
}

struct Publisher: Codable {
    let id: Int
    let name: String
}
