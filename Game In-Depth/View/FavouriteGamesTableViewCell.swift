//
//  FavouriteGamesTableViewCell.swift
//  Game In-Depth
//
//  Created by Indra Permana on 01/08/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class FavouriteGamesTableViewCell: UITableViewCell {

    @IBOutlet weak var favouriteGameImageView: UIImageView!
    @IBOutlet weak var favouriteGameTitle: UILabel!
    @IBOutlet weak var favouriteGameRating: UILabel!
    @IBOutlet weak var favouriteGameReleased: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
