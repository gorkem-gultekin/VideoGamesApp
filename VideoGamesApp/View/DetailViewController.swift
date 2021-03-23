//
//  DetailViewController.swift
//  VideoGamesApp
//
//  Created by Görkem Gültekin on 24.03.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var overview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
    }
}
