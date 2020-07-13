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
    var games: [Game] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ApiManager.shared.fetchPopularGames { (fetchedGames) in
            if let fetchedGames = fetchedGames {
                self.games = fetchedGames
                print(self.games)
                DispatchQueue.main.async {
                    self.mainBannerCollectionView.reloadData()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainBannerCollectionView.delegate = self
        mainBannerCollectionView.dataSource = self
        mainBannerCollectionView.tag = 0
        let nib = UINib(nibName: "MainBannerCollectionViewCell", bundle: nil)
        mainBannerCollectionView.register(nib, forCellWithReuseIdentifier: "MainBannerCellIdentifier")
//        if let flowLayout = self.mainBannerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 414, height: 200)
//        }
    }
    
//    func startDownloadPoster(game:Game, indexPath: IndexPath) {
//        ApiManager.shared.fetchImagePoster(game: game) { (data) in
//            if let imageData = data {
//                DispatchQueue.main.async {
//                    self.posterImageView.image = UIImage(data: imageData)
//                }
//            } else {
//                print("MainBannerCollectionViewCell: error attaching image")
//            }
//        }
//    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBannerCellIdentifier", for: indexPath) as? MainBannerCollectionViewCell
//        cell.configureImageData(game: games[indexPath.row])
        let game = games[indexPath.row]
        if game.download == .new {

            cell?.posterImageView.image = nil
            ApiManager.shared.fetchImagePoster(game: game) { (data) in
                if let imageData = data {
//                    print(imageData)

                    print("ViewController: \(game.backgroundImage)")
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        cell?.posterImageView.image = image
                        print("Image size: \(String(describing: image?.size))")

                        self.games[indexPath.row].download = .downloaded
    //                    cell.configureImageData(data: imageData)
    //                    self.mainBannerCollectionView.reloadItems(at: [indexPath])
                    }
                } else {
                    print("MainBannerCollectionViewCell: error attaching image")
                    DispatchQueue.main.async {
                        self.games[indexPath.row].download = .failed
                    }
                }
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        cell.configureCell(name: names[indexPath.row])
        
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
        let size: CGSize = self.view.frame.size
        print("w: \(size.width)")
        return CGSize(width: size.width, height: 200)
    }
    
    
    
}
