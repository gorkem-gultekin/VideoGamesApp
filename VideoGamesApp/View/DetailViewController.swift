//
//  DetailViewController.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 24.03.2021.
//

import UIKit
import Alamofire
import Kingfisher
import CoreData
class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var likeDislikeButton: UIButton!
    var gameId:Int!
    var gameDetail:DetailModel!
    var liked: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        likedStatus()
        let headers:HTTPHeaders = [
            "x-rapidapi-key": DataService.shared.apiKey,
            "x-rapidapi-host": DataService.shared.apiHost
        ]
        let urlString = "https://rawg-video-games-database.p.rapidapi.com/games/\(gameId!)"
        DispatchQueue.main.async {
            self.fetchDetailGame(urlString:urlString , headers: headers)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        if gameDetail != nil {
            if liked == true{
                gameDetail.dislikeButton()
                likeDislikeButton.setImage(UIImage(named: "like"), for: .normal)
                showError(title: "Notification", message: "Removed From Favorites")
                liked = false
            }else{
                gameDetail.favGameSave()
                likeDislikeButton.setImage(UIImage(named: "dislike1"), for: .normal)
                showError(title: "Notification", message: "Added to Favorites")
                liked = true
            }
        }
    }
}
extension DetailViewController{
    func fetchDetailGame(urlString: String,headers:HTTPHeaders) {
        DataService.shared.fetchDetailGame(urlString: urlString, headers: headers){ [self] (games,error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let games = games{
                gameDetail = DetailModel(detailItem: games)
                let scale = UIScreen.main.scale
                let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: scale * 500.0, height: 300.0 * scale))
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: gameDetail.image,
                                      options: [.processor(resizingProcessor)])
                titleLabel.text = gameDetail.name
                releaseLabel.text = gameDetail.released
                metacriticLabel.text = gameDetail.metacriticRate
                descriptionView.text = gameDetail.description
            }
        }
    }
    
    func likedStatus() {
        var likedGame: Array<LikedModel> = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Likedgames")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let id = result.value(forKey: "id") as? Int{
                    if let name = result.value(forKey: "name") as? String{
                        if let image = result.value(forKey: "image") as? String{
                            if let ratingReleased = result.value(forKey: "ratingReleased") as? String{
                                likedGame.append(LikedModel(id: id, name: name, image: image,ratingReleased:ratingReleased))
                            }
                        }
                    }
                }
            }
        }catch {
            print(error)
        }
        for game in likedGame{
            if game.id == gameId{
                liked = true
                likeDislikeButton.setImage(UIImage(named: "dislike1"), for: .normal)
            }
        }
    }
    func showError(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
}
