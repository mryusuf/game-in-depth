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
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var metascoreAndFavButtonStackView: UIStackView!
    @IBOutlet weak var genreAndReleaseStackView: UIStackView!
    @IBOutlet weak var devAndPublishersStackView: UIStackView!
    var gameId: Int?
    var gameDetail: GameDetail?
    var gameFav: FavouriteGameModel?
    var favouriteGameId: Int?
    var detailPosterImage = UIImage()
    var isFavourite = false {
        didSet {
            if isFavourite {
                DispatchQueue.main.async {
                    self.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
    }
    var isFromFavouriteList = false
    private lazy var favouriteGameProvider: FavouriteGameProvider = {
        return FavouriteGameProvider()
    }()
    var feedbackGenerator: UISelectionFeedbackGenerator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.detailView.isHidden = true
        self.detailDescriptionLabel.text = ""
        self.detailTitleLabel.text =  ""
        self.detailMetacriticLabel.text = ""
        self.detailGenreLabel.text = ""
        self.detailReleaseDateLabel.text = ""
        self.detailDeveloperLabel.text = ""
        self.detailPublisherLabel.text = ""
        self.detailLoading.startAnimating()
        if isFromFavouriteList, let favouriteGameId = favouriteGameId {
            // Get game from Core Data
            favouriteGameProvider.getFavouriteGame(favouriteGameId) { (favouriteGame) in
                if let fetchedGameFavourite = favouriteGame {
                    DispatchQueue.main.async {
                        self.detailLoading.stopAnimating()
                        self.isFavourite = true
                        self.gameFav = fetchedGameFavourite
                        let title = fetchedGameFavourite.name ?? ""
                        let descriptionRaw =  fetchedGameFavourite.descriptionRaw ?? ""
                        let metascore = "Metascore: \(fetchedGameFavourite.metacritic ?? "")"
                        let publishers = fetchedGameFavourite.publishers ?? ""
                        let genres = fetchedGameFavourite.genres ?? ""
                        let developers = fetchedGameFavourite.developers ?? ""
                        let released = fetchedGameFavourite.released ?? ""
                        let backgroundImageURL = fetchedGameFavourite.backgroundImage
                        let backgroundImageDownloaded = fetchedGameFavourite.backgroundImageDownloaded ?? Data()
                        self.setupGameDetailViews(title, descriptionRaw, metascore, genres, developers, publishers, released, backgroundImageURL, backgroundImageDownloaded)
                    }
                }
            }
        } else if let gameId = gameId {
            // Check if game from API (GameDetail) is already saved to favourite
            favouriteGameProvider.getFavouriteGame(gameId) { (game) in
                if game != nil {
                    self.isFavourite = true
                }
            }
            // Fetch detail game from API
            ApiManager.shared.fetchDetailGames(id: gameId) { gameDetail in
                if let fetchedGameDetail = gameDetail {
                    DispatchQueue.main.async {
                        self.detailLoading.stopAnimating()
                        self.gameDetail = fetchedGameDetail
                        let metascore = "Metascore: \(fetchedGameDetail.metacritic!)"
                        let genres = fetchedGameDetail.genres.map { $0.name }.joined(separator: ",")
                        let developers = fetchedGameDetail.developers.map { $0.name }.joined(separator: ",")
                        let publishers = fetchedGameDetail.publishers.map { $0.name }.joined(separator: ",")
                        self.setupGameDetailViews(fetchedGameDetail.name, fetchedGameDetail.descriptionRaw, metascore, genres, developers,
                                                  publishers, fetchedGameDetail.released!, fetchedGameDetail.backgroundImage)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    func setupGameDetailViews(_ title: String, _ description: String, _ metacritic: String, _ genres: String, _ developers: String, _ publishers: String, _ released: String, _ backgroundURL: URL?,
                              _ backgroundImage: Data = Data()) {
        self.detailDescriptionLabel.text = description
        self.detailDescriptionLabel.sizeToFit()
        self.detailTitleLabel.text =  title
        self.detailMetacriticLabel.text = metacritic
        self.detailGenreLabel.text = genres
        self.detailDeveloperLabel.text = developers
        self.detailPublisherLabel.text = publishers
        self.detailReleaseDateLabel.text = released
        self.detailView.isHidden = false
        self.metascoreAndFavButtonStackView.addBackgroundAndBorderedView(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        self.genreAndReleaseStackView.addBackgroundAndBorderedView(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        self.devAndPublishersStackView.addBackgroundAndBorderedView(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        if backgroundImage == Data() {
            self.detailLoading.startAnimating()
            if let backgroundImageURL = backgroundURL {
                ApiManager.shared.fetchImagePoster(imageURL: backgroundImageURL) { (data) in
                    if let imageData = data {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: imageData) {
                                self.detailLoading.stopAnimating()
                                self.setImage(image)
                            }
                        }
                    } else {
                        print("Detail: error attaching image")
                        DispatchQueue.main.async {
                            let image = UIImage(systemName: "nosign")!
                            self.detailLoading.stopAnimating()
                            self.setImage(image)
                        }
                    }
                }
            } else {
                let image = UIImage(systemName: "nosign")!
                self.detailLoading.stopAnimating()
                self.setImage(image)
            }
        } else {
            if let image = UIImage(data: backgroundImage) {
                self.setImage(image)
            }
        }
    }
    @objc func favouriteButtonTapped(_ sender: UIButton) {
        // Preparing Haptic Feedback, doesn't work on Simulator
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        if !isFavourite {
            if !isFromFavouriteList, var game = gameDetail {
                // From API-fetched GameDetail to Core Data
                game.backgroundImageDownloaded = self.detailPosterImageView.image ?? UIImage()
                favouriteGameProvider.createFavouriteGameFromAPI(game: game) {
                    DispatchQueue.main.async {
                        self.feedbackGenerator?.selectionChanged()
                        let message = "Added to Favourite Games"
                        self.presentAlert(message)
                        self.isFavourite = true
                    }
                }
            } else if isFromFavouriteList, let game = gameFav {
                // From FavouriteGame to Core Data, in case user view this page from FavouriteList Page -> defavourite -> favourite again
                favouriteGameProvider.createFavouriteGameFromDB(game: game) {
                    DispatchQueue.main.async {
                        self.feedbackGenerator?.selectionChanged()
                        let message = "Added to Favourite Games"
                        self.presentAlert(message)
                        self.isFavourite = true
                    }
                }
            }
        } else {
            // Delete game in Favourite (Core Data)
            var id = 0
            if !isFromFavouriteList, let game = gameDetail {
                id = game.id
            } else if isFromFavouriteList, let game = gameFav {
                id = Int("\(game.id ?? 0)")!
            }
            print("Game id to delete: \(id)")
            favouriteGameProvider.deleteFavouriteGame(id) {
                DispatchQueue.main.async {
                    self.feedbackGenerator?.selectionChanged()
                    let message = "Deleted from Favourite Games"
                    self.presentAlert(message)
                    self.isFavourite = false
                }
            }
        }
    }
    func setImage(_ image: UIImage) {
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.detailPosterImageView.frame.size.width, height: self.detailPosterImageView.frame.size.height))
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.detailPosterImageView.addSubview(overlayView)
        self.detailPosterImageView.image = image
    }
    func presentAlert(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension UIStackView {
    func addBackgroundAndBorderedView(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.addBorder()
        insertSubview(subView, at: 0)
    }
}

extension UIView {
    func addBorder() {
        let thickness: CGFloat = 1.0
        let topBorder = CALayer()
        let bottomBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: thickness)
        topBorder.backgroundColor = #colorLiteral(red: 0.9685322642, green: 0.9686941504, blue: 0.9685109258, alpha: 1)
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - thickness, width: self.frame.size.width, height: thickness)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        self.layer.addSublayer(topBorder)
        self.layer.addSublayer(bottomBorder)
    }
}
