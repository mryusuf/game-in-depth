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
                // TODO: Download image here
//                for (index,game) in self.mainBannerGames.enumerated() {
//                    ApiManager.shared.fetchImagePoster(game: game) { (data) in
//                        if let imageData = data {
//                            self.mainBannerPosters[game.name] = UIImage(data: imageData)
//                            DispatchQueue.main.async {
//                                self.mainBannerCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
//                            }
//                        }
//                    }
//                }
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
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainBannerGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBannerCellIdentifier", for: indexPath) as? MainBannerCollectionViewCell
        let game = mainBannerGames[indexPath.row]
        cell?.posterImageView.image = mainBannerPosters[game.name]

        if game.download == .new {
            ApiManager.shared.fetchImagePoster(game: game) { (data) in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        print("Image size: \(String(describing: image?.size))")
                        self.mainBannerPosters[game.name] = image
                        self.mainBannerGames[indexPath.row].download = .downloaded
                        self.mainBannerCollectionView.reloadItems(at: [indexPath])
                    }
                } else {
                    print("MainBannerCollectionViewCell: error attaching image")
                    DispatchQueue.main.async {
                        self.mainBannerGames[indexPath.row].download = .failed
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
        let size: CGSize = self.view.frame.size
        print("w: \(size.width)")
        return CGSize(width: size.width, height: 200)
    }
    
    
    
}
