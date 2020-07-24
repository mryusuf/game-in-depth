//
//  ListGameViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 19/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class ListGameViewController: UIViewController {

    @IBOutlet weak var listGameCollectionView: UICollectionView!
    let loadingIndicatorView = UIActivityIndicatorView(style: .large)
    
    var listGames: [Game] = []
    var gamePosters = [String: UIImage]()
    var gameType: ListGameTypes?
    var page = 1
    var pageSize = 10
    var isFetching = false
    var totalCount = 0
    var currentCount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        showLoadingIndicator()
        listGameCollectionView.isHidden = true
        fetchGames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listGameCollectionView.delegate = self
        listGameCollectionView.dataSource = self
        listGameCollectionView.prefetchDataSource = self
        let listGameNib = UINib(nibName: "ListGameCollectionViewCell", bundle: nil)
        
        listGameCollectionView.register(listGameNib, forCellWithReuseIdentifier: "ListGameCollectionViewCell")
    }
    
    func fetchGames() {
        guard !isFetching else { return }
        isFetching = true
        switch gameType {
        case .upcoming:
            ApiManager.shared.fetchAnticipatedGames(pageSize: pageSize, page: page){ (fetchedGames) in
                if let fetchedGames = fetchedGames {
                    DispatchQueue.main.async {
                        self.loadingIndicatorView.stopAnimating()
                        self.listGameCollectionView.isHidden = false
                        self.totalCount = fetchedGames.count
                        self.currentCount = self.page * self.pageSize
                        self.listGames.append(contentsOf: fetchedGames.results!)
                        if self.page > 1 {
                            let newIndexPathsToReload = self.calculateIndexPathForReload(from: fetchedGames.results!)
                            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
                            self.listGameCollectionView.reloadItems(at: indexPathsToReload)
                        } else {
                            self.listGameCollectionView.reloadData()
                        }
                        self.page += 1
                        self.isFetching = false
                    }
                }
            }
        case .topRated:
            ApiManager.shared.fetchHighestRatedGames(pageSize: pageSize, page: page){ (fetchedGames) in
                if let fetchedGames = fetchedGames {
                    DispatchQueue.main.async {
                        self.totalCount = fetchedGames.count
                        self.currentCount = self.page * self.pageSize
                        self.listGames.append(contentsOf: fetchedGames.results!)
                        if self.page > 1 {
                            let newIndexPathsToReload = self.calculateIndexPathForReload(from: fetchedGames.results!)
                            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
                            self.listGameCollectionView.reloadItems(at: indexPathsToReload)
                        } else {
                            self.listGameCollectionView.reloadData()
                        }
                        self.page += 1
                        self.isFetching = false
                    }
                }
            }
        default:
            print("no game types")
        }
    }
    
    func calculateIndexPathForReload(from games: [Game]) -> [IndexPath] {
        let startIndex = listGames.count - games.count
        let endIndex = startIndex + games.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func showLoadingIndicator() {
        loadingIndicatorView.center = self.view.center
        loadingIndicatorView.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadingIndicatorView.hidesWhenStopped = true
        self.view.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
    }

}
extension ListGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching{
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewController") as! DetailGameViewController
        var game: Game?
        game = listGames[indexPath.row]
        vc.detailPosterImage = gamePosters[game?.name ?? ""] ?? UIImage()
        
        
        vc.gameID = game?.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 24
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize/2
        
        let height = width * 363 / 200
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListGameCollectionViewCell", for: indexPath) as? ListGameCollectionViewCell
        if !isLoadingItems(for: indexPath) {
            cell?.listGameLoading.stopAnimating()
            let game = listGames[indexPath.row]
            let padding: CGFloat = 32
            let collectionViewSize = collectionView.frame.size.width - padding
            
            let width = collectionViewSize/2
            
            let height = width * 250 / 200
            cell?.listGameImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            cell?.listGameImageView.translatesAutoresizingMaskIntoConstraints = false
            cell?.listGameImageView.image = gamePosters[game.name]
            cell?.listGameNameLabel.text = game.name
            cell?.listGameRating.text = "rating: \(game.rating?.description ?? "")"
            cell?.listGameReleaseDate.text = "released: \(game.released?.description ?? "")"
            
            if game.imageDownloadstate == .new {
                cell?.listGameLoading.startAnimating()
                ApiManager.shared.fetchImagePoster(imageURL: (game.backgroundImage ?? URL(string: ""))!) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.gamePosters[game.name] = image
                            self.listGames[indexPath.row].imageDownloadstate = .downloaded
                            self.listGameCollectionView.reloadItems(at: [indexPath])
                        }
                    } else {
                        print("UpcommingCollectionView: error attaching image")
                        DispatchQueue.main.async {
                            self.gamePosters[game.name] = UIImage(systemName: "nosign")
                            self.listGames[indexPath.row].imageDownloadstate = .failed
                        }
                    }
                }
            }else {
                cell?.listGameLoading.stopAnimating()
                cell?.listGameLoading.isHidden = true
            }
        } else {
            cell?.listGameLoading.startAnimating()
        }
        return cell ?? UICollectionViewCell()
    }
    
    func isLoadingItems(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= currentCount
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = listGameCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingItems) {
            fetchGames()
        }
    }
       
}
