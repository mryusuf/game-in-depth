//
//  subBannerCollectionViewCell.swift
//  Game In-Depth
//
//  Created by Indra Permana on 14/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class subBannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subPosterImageView: UIImageView!
    @IBOutlet weak var metacriticRatingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subPosterLoading: UIActivityIndicatorView!
    @IBOutlet weak var releaseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
