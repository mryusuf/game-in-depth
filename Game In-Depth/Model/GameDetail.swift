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
    let descriptionRaw: String
    let metacritic: String?
    let released: String?
    let backgroundImage: URL?
    let developers: [Developer]
    let publishers: [Publisher]
    let genres: [Genre]
    let rating: Float?
    var backgroundImageDownloaded: UIImage
    var imageDownloadstate: ImageDownloadStates
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        descriptionRaw = try container.decode(String.self, forKey: .descriptionRaw)
        
        let backgroundImageString = try container.decodeIfPresent(String.self, forKey: .backgroundImage) ?? ""
        backgroundImage = URL(string: backgroundImageString)
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
        rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0
        backgroundImageDownloaded = UIImage()
        imageDownloadstate = .new
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, metacritic, released, developers, publishers, genres, rating
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
    }
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
