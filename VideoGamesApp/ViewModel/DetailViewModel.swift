//
//  DetailViewModel.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 25.03.2021.
//

import Foundation
struct DetailModel {
    let detailItem: GameDetail
}
extension DetailModel{
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
    
    var releaseDate: String{
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
}
