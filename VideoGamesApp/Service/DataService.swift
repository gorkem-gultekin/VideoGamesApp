//
//  DataService.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 23.03.2021.
//

import Foundation
import Alamofire

struct DataService {
    static let shared = DataService()
    
    typealias GameResponse = (Games?,Error?) -> Void
    func fetchGames(urlString:String, headers: HTTPHeaders, completion:@escaping GameResponse) {
        guard let url = URL(string: urlString) else {return}
        AF.request(url,method: .get,headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of:Games.self){(response) in
                switch (response.result) {
                    case .success(_):
                    if let games = response.value {
                    completion(games,nil)
                    }
                    case .failure(_):
                    if response.error != nil {
                        completion(nil,response.error)
                    }
                }
            }
    }
    typealias GameDetailResponse = (GameDetail?,Error?) -> Void
    func fetchDetailGame(urlString:String,headers:HTTPHeaders,completion:@escaping GameDetailResponse) {
        guard let url = URL(string: urlString) else {return}
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GameDetail.self){(response) in
                switch (response.result) {
                    case .success(_):
                    if let gameDetail = response.value {
                    completion(gameDetail,nil)
                    }
                    case .failure(_):
                    if response.error != nil {
                        completion(nil,response.error)
                    }
                }
            }
    }
}
