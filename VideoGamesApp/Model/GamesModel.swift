//
//  GamesModel.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 23.03.2021.
//

import Foundation

struct Games: Decodable {
    let results: [Game]
}
struct Game: Decodable {
    let id: Int
    let name: String
    let released: String
    let rating: Double
    let background_image: String?
}
struct GameDetail: Decodable {
    let id: Int
    let name: String
    let rating: Double
    let released: String
    let metacritic: Int
    let description: String
    let background_image: String?
}
struct LikedModel {
    let id: Int
    let name: String
    let image: String
    let ratingReleased: String
}
