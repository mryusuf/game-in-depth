//
//  ViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 12/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainBannerCollectionView: UICollectionView!
    @IBOutlet weak var upcomingGamesCollectionView: UICollectionView!
    @IBOutlet weak var topGamesCollectionView: UICollectionView!
    @IBOutlet weak var upcomingMoreButton: UIButton!
    @IBOutlet weak var topMoreButton: UIButton!
    @IBOutlet weak var homeScrollView: UIScrollView!
    let loadingIndicatorView = UIActivityIndicatorView(style: .large)
    var mainBannerGames: [Game] = []
    var topGames: [Game] = []
    var upcomingGames: [Game] = []
    var mainBannerPosters = [String: UIImage]()
    var topPosters = [String: UIImage]()
    var upcommingPosters = [String: UIImage]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Popular Games"
        self.navigationController?.hidesBarsOnSwipe = true
        showLoadingIndicator()
        homeScrollView.isHidden = true
        ApiManager.shared.fetchPopularGames { (fetchedGames) in
            if let fetchedGames = fetchedGames {
                self.mainBannerGames = fetchedGames
                DispatchQueue.main.async {
                    self.homeScrollView.isHidden = false
                    self.loadingIndicatorView.stopAnimating()
                    self.mainBannerCollectionView.reloadData()
                }
            }
        }
        ApiManager.shared.fetchAnticipatedGames(pageSize: 5) { (fetchedGames) in
            if let fetchedGames = fetchedGames?.results {
                self.upcomingGames = fetchedGames
                DispatchQueue.main.async {
                    self.homeScrollView.isHidden = false
                    self.loadingIndicatorView.stopAnimating()
                    self.upcomingGamesCollectionView.reloadData()
                }
            }
        }
        ApiManager.shared.fetchHighestRatedGames(pageSize: 5) { (fetchedGames) in
            if let fetchedGames = fetchedGames?.results {
                self.topGames = fetchedGames
                DispatchQueue.main.async {
                    self.homeScrollView.isHidden = false
                    self.loadingIndicatorView.stopAnimating()
                    self.topGamesCollectionView.reloadData()
                }
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainBannerCollectionView.delegate = self
        mainBannerCollectionView.dataSource = self
        mainBannerCollectionView.tag = HomeCollectionViewTag.mainBanner.rawValue
        upcomingGamesCollectionView.delegate = self
        upcomingGamesCollectionView.dataSource = self
        upcomingGamesCollectionView.tag = HomeCollectionViewTag.upcommingBanner.rawValue
        topGamesCollectionView.delegate = self
        topGamesCollectionView.dataSource = self
        topGamesCollectionView.tag = HomeCollectionViewTag.topBanner.rawValue
        let mainBannerNib = UINib(nibName: "MainBannerCollectionViewCell", bundle: nil)
        let subBannerNib = UINib(nibName: "SubBannerCollectionViewCell", bundle: nil)
        mainBannerCollectionView.register(mainBannerNib, forCellWithReuseIdentifier: "MainBannerCellIdentifier")
        upcomingGamesCollectionView.register(subBannerNib, forCellWithReuseIdentifier: "SubBannerCellIdentifier")
        topGamesCollectionView.register(subBannerNib, forCellWithReuseIdentifier: "SubBannerCellIdentifier")
        upcomingMoreButton.addTarget(self, action: #selector(upcomingMoreButtonTapped), for: .touchUpInside)
        topMoreButton.addTarget(self, action: #selector(topMoreButtonTapped), for: .touchUpInside)
    }

    @objc func upcomingMoreButtonTapped() {
        self.title = "Back"
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListGameViewController") as? ListGameViewController {
            vc.gameType = .upcoming
            vc.title = "Upcoming Games"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func topMoreButtonTapped() {
        self.title = "Back"
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListGameViewController") as? ListGameViewController {
            vc.gameType = .topRated
            vc.title = "Top Games"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func showLoadingIndicator() {
        loadingIndicatorView.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
        loadingIndicatorView.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadingIndicatorView.hidesWhenStopped = true
        self.view.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == HomeCollectionViewTag.mainBanner.rawValue {
            return mainBannerGames.count
        } else if collectionView.tag == HomeCollectionViewTag.upcommingBanner.rawValue {
            return upcomingGames.count
        } else if collectionView.tag == HomeCollectionViewTag.topBanner.rawValue {
            return topGames.count
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == HomeCollectionViewTag.mainBanner.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBannerCellIdentifier", for: indexPath) as? MainBannerCollectionViewCell
            let game = mainBannerGames[indexPath.row]
            cell?.posterImageView.image = mainBannerPosters[game.name]
            
            if game.imageDownloadstate == .new {
                cell?.posterLoading.startAnimating()
                if let backgroundImageURL = game.backgroundImage {
                ApiManager.shared.fetchImagePoster(imageURL: backgroundImageURL) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.mainBannerPosters[game.name] = image
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .downloaded
                            self.mainBannerCollectionView.reloadItems(at: [indexPath])
                            cell?.posterLoading.stopAnimating()
                            cell?.posterLoading.isHidden = true
                        }
                    } else {
                        print("MainBannerCollectionViewCell: error attaching image")
                        DispatchQueue.main.async {
                            self.mainBannerPosters[game.name] = UIImage(systemName: "nosign")
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .failed
                            cell?.posterLoading.stopAnimating()
                            cell?.posterLoading.isHidden = true
                        }
                    }
                }
                }
            } else {
                cell?.posterLoading.stopAnimating()
                cell?.posterLoading.isHidden = true
            }
            return cell ?? UICollectionViewCell()
        } else  if collectionView.tag == HomeCollectionViewTag.upcommingBanner.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubBannerCellIdentifier", for: indexPath) as? SubBannerCollectionViewCell
            let game = upcomingGames[indexPath.row]
            cell?.subPosterImageView.image = upcommingPosters[game.name]
            cell?.nameLabel.text = game.name
            cell?.metacriticRatingLabel.text = "rating: \(game.rating?.description ?? "")"
            cell?.releaseLabel.text = "released: \(game.released?.description ?? "")"
            if game.imageDownloadstate == .new {
                cell?.subPosterLoading.startAnimating()
                if let backgroundImageURL = game.backgroundImage {
                ApiManager.shared.fetchImagePoster(imageURL: backgroundImageURL) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {

                            cell?.subPosterLoading.stopAnimating()
                            cell?.subPosterLoading.isHidden = true
                            self.upcommingPosters[game.name] = image
                            self.upcomingGames[indexPath.row].imageDownloadstate = .downloaded
                            self.upcomingGamesCollectionView.reloadItems(at: [indexPath])
                        }
                    } else {
                        print("UpcommingCollectionView: error attaching image")
                        DispatchQueue.main.async {
                            self.upcommingPosters[game.name] = UIImage(systemName: "nosign")
                            cell?.subPosterLoading.stopAnimating()
                            cell?.subPosterLoading.isHidden = true
                            self.upcomingGames[indexPath.row].imageDownloadstate = .failed
                        }
                    }
                }
                }
            } else {
                cell?.subPosterLoading.stopAnimating()
                cell?.subPosterLoading.isHidden = true
            }
            return cell ?? UICollectionViewCell()
        } else  if collectionView.tag == HomeCollectionViewTag.topBanner.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubBannerCellIdentifier", for: indexPath) as? SubBannerCollectionViewCell
            let game = topGames[indexPath.row]
            cell?.subPosterImageView.image = topPosters[game.name]
            cell?.nameLabel.text = game.name
            cell?.metacriticRatingLabel.text = "rating: \(game.rating?.description ?? "")"
            cell?.releaseLabel.text = "released: \(game.released?.description ?? "")"
            if game.imageDownloadstate == .new {
                cell?.subPosterLoading.startAnimating()
                if let backgroundImageURL = game.backgroundImage {
                ApiManager.shared.fetchImagePoster(imageURL: backgroundImageURL) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            cell?.subPosterLoading.stopAnimating()
                            cell?.subPosterLoading.isHidden = true
                            self.topPosters[game.name] = image
                            self.topGames[indexPath.row].imageDownloadstate = .downloaded
                            self.topGamesCollectionView.reloadItems(at: [indexPath])
                        }
                    } else {
                        print("TopCollectionView: error attaching image")
                        DispatchQueue.main.async {
                            self.topPosters[game.name] = UIImage(systemName: "nosign")
                            cell?.subPosterLoading.stopAnimating()
                            cell?.subPosterLoading.isHidden = true
                            self.topGames[indexPath.row].imageDownloadstate = .failed
                        }
                    }
                }
                }
            }else {
                cell?.subPosterLoading.stopAnimating()
                cell?.subPosterLoading.isHidden = true
            }
            return cell ?? UICollectionViewCell()
        }
        
        
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewController") as? DetailGameViewController {
            var game: Game?
            if collectionView.tag == HomeCollectionViewTag.mainBanner.rawValue {
                game = mainBannerGames[indexPath.row]
                vc.detailPosterImage = mainBannerPosters[game?.name ?? ""] ?? UIImage()
                
            } else if collectionView.tag == HomeCollectionViewTag.upcommingBanner.rawValue {
                game = upcomingGames[indexPath.row]
                vc.detailPosterImage = upcommingPosters[game?.name ?? ""] ?? UIImage()
                
            } else if collectionView.tag == HomeCollectionViewTag.topBanner.rawValue {
                game = topGames[indexPath.row]
                vc.detailPosterImage = topPosters[game?.name ?? ""] ?? UIImage()
                
            }
            self.title = "Back"
            vc.gameId = game?.id ?? 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize = self.view.frame.size
        if collectionView.tag == HomeCollectionViewTag.mainBanner.rawValue {
            return CGSize(width: size.width, height: 200)
        } else {
            return CGSize(width: 180, height: 285)
        }
    }
    
    
    
}
