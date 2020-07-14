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
    let name: String
    let backgroundImage: URL
    var download: DownloadState
    var backgroundImageDownloaded: UIImage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let backgroundImageString = try container.decode(String.self, forKey: .backgroundImage)
        
        name = try container.decode(String.self, forKey: .name)
        backgroundImage = URL(string: backgroundImageString)!
        backgroundImageDownloaded = UIImage()
        download = .new
    }

    enum CodingKeys: String, CodingKey {
        case name
        case backgroundImage = "background_image"
    }
}

enum DownloadState {
    case new, downloaded, failed
}
