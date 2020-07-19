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
    @IBOutlet weak var scrollView: UIScrollView!
    var mainBannerGames: [Game] = []
    var topGames: [Game] = []
    var upcomingGames: [Game] = []
    var mainBannerPosters = [String: UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ApiManager.shared.fetchPopularGames { (fetchedGames) in
            if let fetchedGames = fetchedGames {
                self.mainBannerGames = fetchedGames
                print(self.mainBannerGames)
                DispatchQueue.main.async {
                    self.mainBannerCollectionView.reloadData()
                    self.upcomingGamesCollectionView.reloadData()
                    self.topGamesCollectionView.reloadData()
                }
            }
        }
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
        let subBannerNib = UINib(nibName: "subBannerCollectionViewCell", bundle: nil)
        
        mainBannerCollectionView.register(mainBannerNib, forCellWithReuseIdentifier: "MainBannerCellIdentifier")
        upcomingGamesCollectionView.register(subBannerNib, forCellWithReuseIdentifier: "subBannerCellIdentifier")
        topGamesCollectionView.register(subBannerNib, forCellWithReuseIdentifier: "subBannerCellIdentifier")
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
            return mainBannerGames.count
        } else if collectionView.tag == HomeCollectionViewTag.topBanner.rawValue {
            return mainBannerGames.count
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
                ApiManager.shared.fetchImagePoster(game: game) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            //                        print("Image size: \(String(describing: image?.size))")
                            self.mainBannerPosters[game.name] = image
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .downloaded
                            self.mainBannerCollectionView.reloadItems(at: [indexPath])
//                            self.upcomingGamesCollectionView.reloadItems(at: [indexPath])
//                            self.topGamesCollectionView.reloadItems(at: [indexPath])
                        }
                    } else {
                        print("MainBannerCollectionViewCell: error attaching image")
                        DispatchQueue.main.async {
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .failed
                        }
                    }
                }
            }
            return cell!
        } else  if collectionView.tag == HomeCollectionViewTag.upcommingBanner.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subBannerCellIdentifier", for: indexPath) as? subBannerCollectionViewCell
            let game = mainBannerGames[indexPath.row]
            cell?.subPosterImageView.image = mainBannerPosters[game.name]
            cell?.nameLabel.text = game.name
            cell?.metacriticRatingLabel.text = game.metacritic?.description
            
            if game.imageDownloadstate == .new {
                ApiManager.shared.fetchImagePoster(game: game) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            //                        print("Image size: \(String(describing: image?.size))")
                            self.mainBannerPosters[game.name] = image
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .downloaded
                            self.upcomingGamesCollectionView.reloadItems(at: [indexPath])
                        }
                    } else {
                        print("MainBannerCollectionViewCell: error attaching image")
                        DispatchQueue.main.async {
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .failed
                        }
                    }
                }
            }
            return cell!
        } else  if collectionView.tag == HomeCollectionViewTag.topBanner.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subBannerCellIdentifier", for: indexPath) as? subBannerCollectionViewCell
            let game = mainBannerGames[indexPath.row]
            cell?.subPosterImageView.image = mainBannerPosters[game.name]
            cell?.nameLabel.text = game.name
            cell?.metacriticRatingLabel.text = game.metacritic?.description
            
            if game.imageDownloadstate == .new {
                ApiManager.shared.fetchImagePoster(game: game) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            //                        print("Image size: \(String(describing: image?.size))")
                            self.mainBannerPosters[game.name] = image
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .downloaded
                            self.topGamesCollectionView.reloadItems(at: [indexPath])
                        }
                    } else {
                        print("MainBannerCollectionViewCell: error attaching image")
                        DispatchQueue.main.async {
                            self.mainBannerGames[indexPath.row].imageDownloadstate = .failed
                        }
                    }
                }
            }
            return cell!
        }
        
        
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewController") as! DetailGameViewController
        let game = mainBannerGames[indexPath.row]
        vc.gameID = game.id
        vc.detailPosterImage = mainBannerPosters[game.name] ?? UIImage()
        print(mainBannerPosters[game.name]!.size)
        self.navigationController?.pushViewController(vc, animated: true)
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
