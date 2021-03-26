//
//  DetailViewModel.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 25.03.2021.
//

import Foundation
import UIKit
import CoreData

struct DetailModel {
    let detailItem: GameDetail
}
extension DetailModel{
    var id: Int{
        return detailItem.id
    }
    
    var imageString: String{
        if let urlstring = detailItem.background_image{
            return urlstring
        }else{
            return ""
        }
    }
    
    var image: URL?{
        if let urlString = detailItem.background_image{
            let url = URL(string: urlString)
            return url
        }else{
            return nil
        }
    }
    
    var name: String{
        return detailItem.name
    }
    
    var released: String{
        let input = self.detailItem.released
        let words = input.components(separatedBy: "-")
        let date = words[2] + "." + words[1] + "." + words[0]
        return date
    }
    
    var metacriticRate: String{
        return String(detailItem.metacritic)
    }
    
    var description: String{
        let replaced = detailItem.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return replaced
    }
    
    var ratingReleased: String{
        let input = self.detailItem.released
        let words = input.components(separatedBy: "-")
        let date = words[2] + "." + words[1] + "." + words[0]
        return String(detailItem.rating) + " - " + date
    }
    
    func favGameSave() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let item = NSEntityDescription.insertNewObject(forEntityName: "Likedgames", into: context)
        item.setValue(id, forKey: "id")
        item.setValue(name, forKey: "name")
        item.setValue(imageString, forKey: "image")
        item.setValue(ratingReleased, forKey: "ratingReleased")
        do{
            try context.save()
        }catch{
            print("Item can't be created: \(error.localizedDescription)")
        }
    }
    
    func dislikeButton() {
        var likedGame: Array<LikedModel> = []
        likedGame.removeAll(keepingCapacity: false)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likedgames")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let resultId = result.value(forKey: "id") as? Int{
                    if resultId == id{
                        context.delete(result)
                        do {
                            try context.save()
                        }catch{
                            print("error")
                        }
                        break
                    }
                }
            }
        }catch {
            print(error)
        }
    }
}
