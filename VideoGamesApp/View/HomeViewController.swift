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
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    var fullGameList: GameListViewModel!
    var sliderGameModel: GameListViewModel!
    var listGameModel: GameListViewModel!
    var searchData: GameListViewModel!
    fileprivate var currentPage: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        listCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let headers:HTTPHeaders = [
            "x-rapidapi-key": "c42dffd9f3msh2cbb0c354c7ab5ep11475bjsnc873c3d8b693",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
        let urlString = "https://rawg-video-games-database.p.rapidapi.com/games"
        DispatchQueue.main.async {
            self.FetchGames(urlString:urlString , headers: headers)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return self.sliderGameModel == nil ? 0 : self.sliderGameModel.numberOfRowsInSection()
        }else if collectionView.tag == 1{
            return self.listGameModel == nil ? 0 : self.listGameModel.numberOfRowsInSection()
        }else{
            return self.searchData == nil ? 0 : self.searchData.numberOfRowsInSection()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageSide = self.sliderCollectionView.frame.width
            let offset = scrollView.contentOffset.x
            currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            pageView.currentPage = currentPage
            print("currentPage " + currentPage.description)
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCollectionViewCell
            let sliderItem = self.sliderGameModel.gameAtIndex(indexPath.row)
            let scale = UIScreen.main.scale
            let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: scale * 500.0, height: 300.0 * scale))
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: sliderItem.image, options:[.processor(resizingProcessor)])
           
            return cell
        }else if collectionView.tag == 1{
            return Cells(indexPath: indexPath, model: listGameModel)
        }else{
            return Cells(indexPath: indexPath, model: searchData)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SelectItem(index: indexPath.row, collectionView: collectionView)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Search(searchText: searchText)
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func FetchGames(urlString: String,headers:HTTPHeaders) {
        DataService.shared.fetchGames(urlString: urlString, headers: headers){ [self](games,error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let games = games?.results{
                fullGameList = GameListViewModel(gameList: games)
                sliderGameModel = GameListViewModel(gameList: Array(games.prefix(3)))
                listGameModel = GameListViewModel(gameList: Array(games.suffix(games.count - 3)))
                listCollectionView.reloadData()
                sliderCollectionView.reloadData()
            }
        }
    }
    func Cells(indexPath:IndexPath,model:GameListViewModel) -> GameCell {
        let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GameCell
        let listItem = model.gameAtIndex(indexPath.row)
        let scale = UIScreen.main.scale
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: scale * 100.0, height: 50.0 * scale))
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: listItem.image,
                              options: [.processor(resizingProcessor)])
            cell.titleLabel.text = listItem.name
            cell.ratingReleasedLabel.text = listItem.ratingReleased
        return cell
    }
    func SelectItem(index:Int, collectionView:UICollectionView )  {
        let vc = storyboard?.instantiateViewController(identifier: "DetailPage") as! DetailViewController
        if collectionView.tag == 0{
            let gameViewModel = sliderGameModel.gameAtIndex(index)
            vc.gameId = gameViewModel.id
        }else if collectionView.tag == 1{
            let gameViewModel = listGameModel.gameAtIndex(index)
            vc.gameId = gameViewModel.id
        }else{
            let gameViewModel = searchData.gameAtIndex(index)
            vc.gameId = gameViewModel.id
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func Search(searchText:String) {
        DispatchQueue.main.async { [self] in
            if searchText.count >= 3{
                sliderCollectionView.isHidden = true
                listCollectionView.isHidden = true
                pageView.isHidden = true
                let data = fullGameList.gameList.filter{$0.name.range(of: searchText, options: .caseInsensitive) != nil }
                searchData = GameListViewModel(gameList: data)
                searchCollectionView.reloadData()
            }else if searchText.count < 3{
                sliderCollectionView.isHidden = false
                listCollectionView.isHidden = false
                pageView.isHidden = false
            }
        }
    }
    func labelShow(open:Bool){
        let label = UILabel()
        label.text = "Üzgünüz, aradığınız oyun bulunamadı!"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.sizeToFit()
        label.center = self.view.center
        self.view.addSubview(label)
        if open == true{
            label.isHidden = false
        }else if open == false{
            label.isHidden = true
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
