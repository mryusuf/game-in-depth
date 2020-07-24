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
    @IBOutlet weak var detailLoading: UIActivityIndicatorView!
    var gameID = 0
    var game: GameDetail?
    var detailPosterImage = UIImage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.detailDescriptionLabel.text = ""
        self.detailTitleLabel.text =  ""
        self.detailMetacriticLabel.text = ""
        self.detailGenreLabel.text = ""
        self.detailReleaseDateLabel.text = ""
        self.detailDeveloperLabel.text = ""
        self.detailPublisherLabel.text = ""
        self.detailLoading.startAnimating()
        ApiManager.shared.fetchDetailGames(id: gameID) { fetchedGameDetail in
            if let fetchedGameDetail = fetchedGameDetail {
                DispatchQueue.main.async {
                    self.detailLoading.stopAnimating()
                    self.game = fetchedGameDetail
                    self.detailDescriptionLabel.text = fetchedGameDetail.description_raw
                    self.detailDescriptionLabel.sizeToFit()
                    self.detailTitleLabel.text =  fetchedGameDetail.name
                    self.detailMetacriticLabel.text = " Metascore: \(fetchedGameDetail.metacritic!)"
                    let genres = fetchedGameDetail.genres.map{$0.name}.joined(separator: ",")
                    self.detailGenreLabel.text = genres
                    let developers = fetchedGameDetail.developers.map{$0.name}.joined(separator: ",")
                    self.detailDeveloperLabel.text = developers
                    let publishers = fetchedGameDetail.publishers.map{$0.name}.joined(separator: ",")
                    self.detailPublisherLabel.text = publishers
                    self.detailReleaseDateLabel.text = fetchedGameDetail.released
                    if self.detailPosterImage == UIImage() {
                        self.detailLoading.startAnimating()
                        ApiManager.shared.fetchImagePoster(imageURL: self.game!.backgroundImage) { (data) in
                            if let imageData = data {
                                if let image = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    self.detailPosterImage = image
                                    self.detailLoading.stopAnimating()
                                    self.setImage()
                                }
                                }
                            } else {
                                print("Detail: error attaching image")
                                DispatchQueue.main.async {
                                    self.detailPosterImage = UIImage(systemName: "nosign")!
                                    self.detailLoading.stopAnimating()
                                    self.setImage()
                                }
                            }
                        }
                    } else {
                        self.setImage()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setImage() {
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.detailPosterImageView.frame.size.width, height: self.detailPosterImageView.frame.size.height))
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.detailPosterImageView.addSubview(overlayView)
        self.detailPosterImageView.image = self.detailPosterImage
    }
    
}
