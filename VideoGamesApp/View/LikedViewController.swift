//
//  LikedViewController.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 23.03.2021.
//

import UIKit
import CoreData
import Kingfisher

class LikedViewController: UICollectionViewController {
    
    private var likedGame: Array<LikedModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "LikedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        getData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedGame.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LikedCell", for: indexPath) as! GameCell
        let item = likedGame[indexPath.row]
        let url = URL(string: item.image)
        let scale = UIScreen.main.scale
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: scale * 500.0, height: 300.0 * scale))
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url, options: [.processor(resizingProcessor)])
        
        cell.titleLabel.text = item.name
        cell.ratingReleasedLabel.text = item.ratingReleased
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailPage") as! DetailViewController
        vc.gameId = likedGame[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension LikedViewController{
    func getData() {
        likedGame.removeAll(keepingCapacity: false)
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
                                    collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }catch {
            print(error)
        }
    }
}
