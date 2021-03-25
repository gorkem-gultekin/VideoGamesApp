//
//  DetailViewController.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 24.03.2021.
//

import UIKit
import Alamofire
import Kingfisher
class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    var gameId:Int!
    var gameDetail:DetailModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let headers:HTTPHeaders = [
            "x-rapidapi-key": "c42dffd9f3msh2cbb0c354c7ab5ep11475bjsnc873c3d8b693",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
        let urlString = "https://rawg-video-games-database.p.rapidapi.com/games/\(gameId!)"
        DispatchQueue.main.async {
            self.fetchDetailGame(urlString:urlString , headers: headers)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
    }
}
extension DetailViewController{
    func fetchDetailGame(urlString: String,headers:HTTPHeaders) {
        DataService.shared.fetchDetailGame(urlString: urlString, headers: headers){ [self] (games,error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let games = games{
                gameDetail = DetailModel(detailItem: games)
                DispatchQueue.main.async {
                    KF.url(gameDetail.image).loadDiskFileSynchronously().cacheMemoryOnly()
                        .fade(duration: 0.1)
                        .set(to: imageView)
                }
                titleLabel.text = gameDetail.name
                releaseLabel.text = gameDetail.releaseDate
                metacriticLabel.text = gameDetail.metacriticRate
                descriptionView.text = gameDetail.description
                
            }
        }
    }
}
