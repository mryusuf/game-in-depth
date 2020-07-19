//
//  DetailGameViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 19/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class DetailGameViewController: UIViewController {

    @IBOutlet weak var detailPosterImageView: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailMetacriticLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailGenreLabel: UILabel!
    @IBOutlet weak var detailReleaseDateLabel: UILabel!
    @IBOutlet weak var detailDeveloperLabel: UILabel!
    @IBOutlet weak var detailPublisherLabel: UILabel!
    
    var gameID = 0
    var detailPosterImage = UIImage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        ApiManager.shared.fetchDetailGames(id: gameID) { gamedetail in
            
            DispatchQueue.main.async {
                self.detailDescriptionLabel.text = gamedetail?.description_raw
                self.detailDescriptionLabel.sizeToFit()
                self.detailTitleLabel.text =  gamedetail?.name
                self.detailMetacriticLabel.text = " Metacritic Score: \(gamedetail?.metacritic! ?? "Not Available")"
                let genres = gamedetail?.genres.map{$0.name}.joined(separator: ",")
                self.detailGenreLabel.text = genres
                let developers = gamedetail?.developers.map{$0.name}.joined(separator: ",")
                print(developers?.description)
                self.detailDeveloperLabel.text = developers
                let publishers = gamedetail?.publishers.map{$0.name}.joined(separator: ",")
                self.detailPublisherLabel.text = publishers
                self.detailReleaseDateLabel.text = gamedetail?.released
                let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.detailPosterImageView.frame.size.width, height: self.detailPosterImageView.frame.size.height))
                overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.detailPosterImageView.addSubview(overlayView)
                self.detailPosterImageView.image = self.detailPosterImage
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
