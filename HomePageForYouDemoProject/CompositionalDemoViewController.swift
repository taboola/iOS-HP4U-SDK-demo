//
//  CompositionalDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 16.08.2022.
//

import UIKit
import TaboolaSDK

class CompositionalDemoViewController: BaseDemoViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = compositionalLayout
        setScrollView(collectionView)
        datasource.fetchArticles { items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription ?? ""))")
                return
            }
            self.collectionView.reloadData()
        }
    }

    let compositionalLayout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        let fraction: CGFloat = 1
        let isTopNewsSection = sectionIndex == 0

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)

        // Section
        let section = NSCollectionLayoutSection(group: group)

        // Header
        // header is not added to the first section
        if !isTopNewsSection {
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
        }

        return section
    })
}
