//
//  ListGameCollectionViewCell.swift
//  Game In-Depth
//
//  Created by Indra Permana on 19/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class ListGameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var listGameImageView: UIImageView!
    @IBOutlet weak var listGameNameLabel: UILabel!
    @IBOutlet weak var listGameRating: UILabel!
    @IBOutlet weak var listGameReleaseDate: UILabel!
    @IBOutlet weak var listGameLoading: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
