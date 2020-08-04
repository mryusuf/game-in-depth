//
//  FavouriteGameProvider.swift
//  Game In-Depth
//
//  Created by Indra Permana on 01/08/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit
import CoreData

class FavouriteGameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameCoreDataModel")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavouriteGames(completion: @escaping(_ games: [FavouriteGameModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteGame")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [FavouriteGameModel] = []
                for result in results {
                    let game = FavouriteGameModel(id: result.value(forKeyPath: "id") as? Int32,
                                             name: result.value(forKeyPath: "name") as? String,
                                             descriptionRaw: result.value(forKeyPath: "descriptionRaw") as? String,
                                             metacritic: result.value(forKeyPath: "metacritic") as? String,
                                             released: result.value(forKeyPath: "released") as? String,
                                             backgroundImage: result.value(forKeyPath: "backgroundImage") as? URL,
                                             developers: result.value(forKeyPath: "developers") as? String,
                                             publishers: result.value(forKeyPath: "publishers") as? String,
                                             genres: result.value(forKeyPath: "genres") as? String,
                                             rating: result.value(forKeyPath: "rating") as? Float,
                                             backgroundImageDownloaded: result.value(forKeyPath: "backgroundImageDownloaded") as? Data
                    )
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getFavouriteGame(_ id: Int, completion: @escaping(_ game: FavouriteGameModel?) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    let game = FavouriteGameModel(id: result.value(forKeyPath: "id") as? Int32,
                                             name: result.value(forKeyPath: "name") as? String,
                                             descriptionRaw: result.value(forKeyPath: "descriptionRaw") as? String,
                                             metacritic: result.value(forKeyPath: "metacritic") as? String,
                                             released: result.value(forKeyPath: "released") as? String,
                                             backgroundImage: result.value(forKeyPath: "backgroundImage") as? URL,
                                             developers: result.value(forKeyPath: "developers") as? String,
                                             publishers: result.value(forKeyPath: "publishers") as? String,
                                             genres: result.value(forKeyPath: "genres") as? String,
                                             rating: result.value(forKeyPath: "rating") as? Float,
                                             backgroundImageDownloaded: result.value(forKeyPath: "backgroundImageDownloaded") as? Data
                    )
                    completion(game)
                } else {
                    completion(nil)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func createFavouriteGameFromAPI(game: GameDetail, completion: @escaping() -> Void) {
        let id = Int32(game.id)
        let name = game.name
        let descriptionRaw = game.descriptionRaw
        let metacritic = game.metacritic ?? ""
        let released = game.released ?? ""
        let backgroundImageURL = game.backgroundImage
        let rating = game.rating ?? 0
        let backgroundImageDownloaded = game.backgroundImageDownloaded.jpegData(compressionQuality: 1) ?? Data()
        let genres = game.genres.map {$0.name}.joined(separator: ",")
        let developers = game.developers.map { $0.name }.joined(separator: ",")
        let publishers = game.publishers.map { $0.name }.joined(separator: ",")
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "FavouriteGame", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                    game.setValue(id, forKeyPath: "id")
                    game.setValue(name, forKeyPath: "name")
                    game.setValue(descriptionRaw, forKeyPath: "descriptionRaw")
                    game.setValue(metacritic, forKeyPath: "metacritic")
                    game.setValue(released, forKeyPath: "released")
                    game.setValue(backgroundImageURL, forKeyPath: "backgroundImage")
                    game.setValue(developers, forKeyPath: "developers")
                    game.setValue(publishers, forKeyPath: "publishers")
                    game.setValue(genres, forKeyPath: "genres")
                    game.setValue(rating, forKeyPath: "rating")
                    game.setValue(backgroundImageDownloaded, forKeyPath: "backgroundImageDownloaded")
                    
                    do {
                        try taskContext.save()
                        completion()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
            }
        }
    }
    func createFavouriteGameFromDB(game: FavouriteGameModel, completion: @escaping() -> Void ) {
        let id = game.id ?? 0
        let name = game.name ?? ""
        let descriptionRaw =  game.descriptionRaw ?? ""
        let metacritic = game.metacritic ?? ""
        let publishers = game.publishers ?? ""
        let genres = game.genres ?? ""
        let developers = game.developers ?? ""
        let released = game.released ?? ""
        let rating = game.rating ?? 0
        let backgroundImageURL = game.backgroundImage
        let backgroundImageDownloaded = game.backgroundImageDownloaded ?? Data()
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "FavouriteGame", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                    game.setValue(id, forKeyPath: "id")
                    game.setValue(name, forKeyPath: "name")
                    game.setValue(descriptionRaw, forKeyPath: "descriptionRaw")
                    game.setValue(metacritic, forKeyPath: "metacritic")
                    game.setValue(released, forKeyPath: "released")
                    game.setValue(backgroundImageURL, forKeyPath: "backgroundImage")
                    game.setValue(developers, forKeyPath: "developers")
                    game.setValue(publishers, forKeyPath: "publishers")
                    game.setValue(genres, forKeyPath: "genres")
                    game.setValue(rating, forKeyPath: "rating")
                    game.setValue(backgroundImageDownloaded, forKeyPath: "backgroundImageDownloaded")
                    do {
                        try taskContext.save()
                        completion()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
            }
        }
    }
    func deleteFavouriteGame(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                print("Delete Favourite Game ok")
                completion()
            } else {
                print("Error while Deleting Favourite Game")
            }
        }
    }
    func deleteAllFavouriteGame(completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteGame")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                print("All games deleted")
                completion()
            }
        }
    }
}
