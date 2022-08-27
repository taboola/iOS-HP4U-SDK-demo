//
//  ViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import UIKit
import TaboolaSDK

class DemoViewController: BaseDemoViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionLayout: UICollectionViewFlowLayout! { didSet { collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize } }

    override func viewDidLoad() {
        isFlowLayout = true
        super.viewDidLoad()
        // setup view
        setScrollView(collectionView)
        // fetch publisher's content
        datasource.fetchArticles { items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription ?? ""))")
                return
            }
            self.collectionView.reloadData()
        }
    }
}

extension DemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        section == 0 ? .zero : CGSize(width: collectionView.frame.width, height: 50)
    }
}
