//
//  HomeViewController.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 23.03.2021.
//

import UIKit
import Alamofire
import Kingfisher

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    var gameListModel: GameListViewModel!
    var sliderGameModel: GameListViewModel!
    var listGameModel: GameListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        listCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let headers:HTTPHeaders = [
            "x-rapidapi-key": "c42dffd9f3msh2cbb0c354c7ab5ep11475bjsnc873c3d8b693",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
        let urlString = "https://rawg-video-games-database.p.rapidapi.com/games"
        DispatchQueue.main.async {
            self.fetchGames(urlString:urlString , headers: headers)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            pageView.currentPage = indexPath.row
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return self.sliderGameModel == nil ? 0 : self.sliderGameModel.numberOfRowsInSection()
        }else{
            return self.listGameModel == nil ? 0 : self.listGameModel.numberOfRowsInSection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCollectionViewCell
            let sliderItem = self.sliderGameModel.gameAtIndex(indexPath.row)
            DispatchQueue.main.async {
                KF.url(sliderItem.image).loadDiskFileSynchronously().cacheMemoryOnly()
                    .fade(duration: 0.1)
                    .set(to: cell.imageView)
            }
            return cell
        }else{
            let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! GameCell
            let listItem = self.listGameModel.gameAtIndex(indexPath.row)
            DispatchQueue.main.async {
                KF.url(listItem.image).loadDiskFileSynchronously().cacheMemoryOnly()
                    .fade(duration: 0.1)
                    .set(to: cell.imageView)
            }
            cell.titleLabel.text = listItem.name
            cell.ratingReleasedLabel.text = listItem.ratingReleased
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailPage") as! DetailViewController
        if collectionView.tag == 0{
            let gameViewModel = sliderGameModel.gameAtIndex(indexPath.row)
            vc.gameId = gameViewModel.id
        }else{
            let gameViewModel = listGameModel.gameAtIndex(indexPath.row)
            vc.gameId = gameViewModel.id
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func fetchGames(urlString: String,headers:HTTPHeaders) {
        DataService.shared.fetchGames(urlString: urlString, headers: headers){ [self](games,error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let games = games?.results{
                
                gameListModel = GameListViewModel(gameList: games)
                sliderGameModel = GameListViewModel(gameList: Array(games.prefix(3)))
                listGameModel = GameListViewModel(gameList: Array(games.suffix(games.count - 3)))
                listCollectionView.reloadData()
                sliderCollectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width:size.width , height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
