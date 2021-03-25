//
//  HomeViewModel.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 24.03.2021.
//

import Foundation
struct GameListViewModel{
    let gameList:[Game]
    
    func numberOfRowsInSection() -> Int {
        return self.gameList.count
    }
    func gameAtIndex(_ index:Int) -> GameViewModel {
        let gameItem = self.gameList[index]
        return GameViewModel(game: gameItem)
    }
}
struct GameViewModel {
    let game: Game
    
    var id:Int{
        return game.id
    }
    var name: String{
        return game.name
    }
    var ratingReleased: String{
        let input = self.game.released
        let words = input.components(separatedBy: "-")
        let date = words[2] + "." + words[1] + "." + words[0]
        return String(game.rating) + " - " + date
    }
    var image: URL?{
        if let urlString = game.background_image{
            let url = URL(string: urlString)
            return url
        }else{
            return nil
        }
    }
    var detailPage: String{
        return "deneme"
    }
    
}

