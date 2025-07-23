//
//  ViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import UIKit
import TaboolaSDK

class DemoViewController: BaseDemoViewController {
    
    @IBOutlet private var collectionLayout: UICollectionViewFlowLayout! {
        didSet { collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isWithFeed = true
        // setup view
        setScrollView(collectionView)
    }
    //    MARK: - Helpers
    private func isClassicUnitCellFor(_ indexPath:IndexPath) -> Bool {
        return indexPath.section == datasource.allTopics.count - 1 && indexPath.item ==  datasource.allTopics.count
    }
}

// MARK: - UICollectionViewDataSource

extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isClassicUnitCellFor(indexPath) {
            if let classicUnit  {
                // get a cell managed by Taboola SDK
                let cell = classicUnit.collectionView(collectionView, cellForItemAt: indexPath, withBackground: nil)
                return cell
            }
            print("Unit not created")
            return UICollectionViewCell()
        }
        
        // get cell reuse identifier for this indexPath
        let identifier = LayoutConfig.cellIdentifier(at: indexPath).rawValue
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopNewsFlowLayoutCell else {
            return UICollectionViewCell()
        }
        // get topic name and item for this indexPath
        guard let topic = datasource.topicName(at: indexPath.section),
              let item = datasource.item(in: topic, at: indexPath.row) else { return cell }
        
        // shouldSwapItem(...) returns whether this cell is going to be swapped by Taboola HomePage
        if let page, page.shouldSwapItem(inSection: topic,
                                         indexPath: indexPath,
                                         parentView: cell.contentView,
                                         titleView: cell.titleLabel,
                                         descriptionView: cell.subtitleLabel,
                                         imageView: cell.imageView,
                                         additionalViews: nil) {
            cell.isSwapped = true
        } else {
            // if not swapped, set publisher's content
            cell.imageView.image = UIImage(named: item.imageName) ?? UIImage.placeholder
            cell.isSwapped = false
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.description
        }
        // autolayout adjustment for cell width
        cell.widthConstraint.constant = collectionView.frame.width
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        section == 0 ? .zero : CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widgetSize = CGSize(width: self.view.frame.size.width, height: 150)
        
        if isClassicUnitCellFor(indexPath) {
            if let taboolaSize = classicUnit?.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath, withUIInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) {
                widgetSize = taboolaSize
            }
        }
        return widgetSize
    }
}

