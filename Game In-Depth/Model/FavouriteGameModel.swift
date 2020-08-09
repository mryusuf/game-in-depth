//
//  FavouriteGame.swift
//  Game In-Depth
//
//  Created by Indra Permana on 01/08/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import Foundation

struct FavouriteGameModel {
    var gameId: Int32?
    var name: String?
    var descriptionRaw: String?
    var metacritic: String?
    var released: String?
    var backgroundImage: URL?
    var developers: String?
    var publishers: String?
    var genres: String?
    var rating: Float?
    var backgroundImageDownloaded: Data?
}
