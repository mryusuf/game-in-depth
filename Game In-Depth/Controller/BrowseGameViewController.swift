//
//  BrowseGameViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 22/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class BrowseGameViewController: UIViewController {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchLoading: UIActivityIndicatorView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var gameResults: [Game] = []
    var gameResultPosters = [String: UIImage]()
    var page = 1
    var pageSize = 10
    var isFetching = false
    var totalCount = 0
    var currentCount = 0
    var query = ""
    var searchTask: DispatchWorkItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Game Titles"
        navigationItem.searchController = searchController
        
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.prefetchDataSource = self
        let listGameNib = UINib(nibName: "ListGameCollectionViewCell", bundle: nil)
        
        searchCollectionView.register(listGameNib, forCellWithReuseIdentifier: "ListGameCollectionViewCell")
    }
    
    func fetchGames(query: String) {
            guard !isFetching else { return }
            isFetching = true
        searchLoading.startAnimating()
        ApiManager.shared.fetchSearchGames(query: query, pageSize: pageSize, page: page){ (fetchedGames) in
                    if let fetchedGames = fetchedGames {
                        DispatchQueue.main.async {
                            self.totalCount = fetchedGames.count

                            self.searchLoading.stopAnimating()
                            if self.totalCount == 0 {
                                self.noResultLabel.isHidden = false
                                self.searchCollectionView.isHidden = true
                                self.isFetching = false
                            } else {
                            self.noResultLabel.isHidden = true
                            self.searchCollectionView.isHidden = false
                            self.currentCount = self.page * self.pageSize
                                self.gameResults.append(contentsOf: fetchedGames.results!)
                            if self.page > 1 {
                                let newIndexPathsToReload = self.calculateIndexPathForReload(from: fetchedGames.results!)
                                let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
                                self.searchCollectionView.reloadItems(at: indexPathsToReload)
                            } else {
                                self.searchCollectionView.reloadData()
                            }
                            self.page += 1
                            self.isFetching = false
                            }
                        }
                    }
                }

        }
        
        func calculateIndexPathForReload(from games: [Game]) -> [IndexPath] {
            let startIndex = gameResults.count - games.count
            let endIndex = startIndex + games.count
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        }
}

extension BrowseGameViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let queryText = searchController.searchBar.text, queryText.isEmpty == false else { return }
        
        // Cancel previous task if any
        self.searchTask?.cancel()

        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            self?.query = queryText
            self?.pageSize = 10
            self?.page = 1
            //        isFetching = true
            //        ApiManager.shared.fetchSearchGames(stop: true, query: query, pageSize: pageSize, page: page) {_ in
            //
            //        }
            self?.gameResults = []
            self?.searchCollectionView.reloadData()
            self?.fetchGames(query: queryText)
        }
        self.searchTask = task

        // Execute task in 0.75 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)

        
    }
}

extension BrowseGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching{
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewController") as! DetailGameViewController
        var game: Game?
        game = gameResults[indexPath.row]
        vc.detailPosterImage = gameResultPosters[game?.name ?? ""] ?? UIImage()
        
        
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
        if !isLoadingItems(for: indexPath) && gameResults.count > 0 {
            cell?.listGameLoading.stopAnimating()
            let game = gameResults[indexPath.row]
            let padding: CGFloat = 32
            let collectionViewSize = collectionView.frame.size.width - padding
            
            let width = collectionViewSize/2
            
            let height = width * 250 / 200
            cell?.listGameImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            cell?.listGameImageView.translatesAutoresizingMaskIntoConstraints = false
            cell?.listGameImageView.image = gameResultPosters[game.name]
    //
    //        print("W: \(cell?.listGameImageView.frame.width), H: \(cell?.listGameImageView.frame.height)")
            cell?.listGameNameLabel.text = game.name
            cell?.listGameRating.text = game.metacritic?.description
            cell?.listGameReleaseDate.text = game.released
            
            if game.imageDownloadstate == .new {
                cell?.listGameLoading.startAnimating()
                if !self.isFetching {
                if let backgroundImage = game.backgroundImage {
                ApiManager.shared.fetchImagePoster(imageURL: backgroundImage) { (data) in
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            if self.gameResults.count > indexPath.row {
                                cell?.listGameLoading.stopAnimating()
                                cell?.listGameLoading.isHidden = true
                            self.gameResultPosters[game.name] = image
                            self.gameResults[indexPath.row].imageDownloadstate = .downloaded
                            self.searchCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    } else {
                        print("UpcommingCollectionView: error attaching image")
                        DispatchQueue.main.async {
                             if self.gameResults.count > indexPath.row  {
                                cell?.listGameLoading.stopAnimating()
                                cell?.listGameLoading.isHidden = true
                            self.gameResultPosters[game.name] = UIImage(systemName: "nosign")
                            self.gameResults[indexPath.row].imageDownloadstate = .failed
                            self.searchCollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                }
                } else {
                    self.gameResultPosters[game.name] = UIImage(systemName: "nosign")
                    self.gameResults[indexPath.row].imageDownloadstate = .failed
                    self.searchCollectionView.reloadItems(at: [indexPath])
                }
            }else {
                cell?.listGameLoading.stopAnimating()
                cell?.listGameLoading.isHidden = true
            }
            }
        } else {
            cell?.listGameLoading.startAnimating()
        }
        return cell!
    }
    
    func isLoadingItems(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= currentCount
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = searchCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingItems) {
            fetchGames(query: query)
        }
    }
       
}


