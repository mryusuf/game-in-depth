//
//  ListFavouriteGameViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 01/08/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit

class ListFavouriteGameViewController: UIViewController {

    @IBOutlet weak var listFavouriteGameTableView: UITableView!
    var favouriteGames: [FavouriteGameModel] = []
    private lazy var favouriteGamesProvider: FavouriteGameProvider = {
        return FavouriteGameProvider()
    }()
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height / 2, width: self.view.frame.size.width, height: 40))
        label.text = "No Games in your Favourite List :("
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        label.isHidden = true
        return label
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Load Games from CoreData, if null, hide tableview, show empty state label
        favouriteGamesProvider.getAllFavouriteGames {(games) in
            DispatchQueue.main.async {
                if games.count == 0 {
                    print("no games")
                    self.listFavouriteGameTableView.isHidden = true
                    self.emptyStateLabel.isHidden = false
                    self.view.addSubview(self.emptyStateLabel)
                } else {
                    self.emptyStateLabel.isHidden = true
                    self.listFavouriteGameTableView.isHidden = false
                    self.favouriteGames = games
                    self.listFavouriteGameTableView.reloadData()
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFavouriteGameTableView.delegate = self
        listFavouriteGameTableView.dataSource = self
    }
    
}

extension ListFavouriteGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = favouriteGames[indexPath.row].gameId {
            let gameId = Int(id)
            if let vc = UIStoryboard(name: "DetailGameView", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewController") as? DetailGameViewController {
                vc.detailPosterImage = UIImage()
                vc.favouriteGameId = gameId
                vc.isFromFavouriteList = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ListFavouriteGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteGameCell", for: indexPath) as? FavouriteGamesTableViewCell {
            let game = favouriteGames[indexPath.row]
            cell.favouriteGameTitle.text = game.name
            cell.favouriteGameReleased.text = "released: \(game.released ?? "")"
            cell.favouriteGameRating.text = "rating: \(game.rating?.description ?? "")"
            
            if let image = game.backgroundImageDownloaded {
                cell.favouriteGameImageView.image = UIImage(data: image)
            } else {
                cell.favouriteGameImageView.image = UIImage(systemName: "nosign")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
   
}
