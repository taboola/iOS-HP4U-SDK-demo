//
//  CompositionalDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 16.08.2022.
//

import UIKit
import TaboolaSDK

class CompositionalDemoViewController: BaseDemoViewController {

    /// Returns a compositional layout
    private let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        let fraction: CGFloat = 1
        let isTopNewsSection = sectionIndex == 0
        
        // Item
        let height: NSCollectionLayoutDimension = isTopNewsSection ? .fractionalWidth(fraction) : .estimated(100)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: height)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: height)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        if !isTopNewsSection {
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(50))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
        }
        
        return section
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup view
        collectionView.collectionViewLayout = compositionalLayout
        setScrollView(collectionView)
    }
}

// MARK: - UICollectionViewDataSource

extension CompositionalDemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get cell reuse identifier for this indexPath
        let identifier = LayoutConfig.cellIdentifier(at: indexPath).rawValue
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopNewsCompositionalLayoutCell else {
            return UICollectionViewCell()
        }
        // get topic name and item for this indexPath
        guard let topic = datasource.topicName(at: indexPath.section),
              let item = datasource.item(in: topic, at: indexPath.row) else { return cell }

        // shouldSwapItem(...) returns whether this cell is going to be swapped by Taboola HomePage
        if page.shouldSwapItem(inSection: topic,
                               indexPath: indexPath,
                               parentView: cell.contentView,
                               imageView: cell.imageView,
                               titleView: cell.titleLabel,
                               descriptionView: cell.subtitleLabel,
                               additionalViews: nil) {
            cell.isSwapped = true
        } else {
            // if not swapped, set publisher's content
            cell.imageView.image = UIImage(named: item.imageName) ?? UIImage.placeholder
            cell.isSwapped = false
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.description
        }

        return cell
    }
}
