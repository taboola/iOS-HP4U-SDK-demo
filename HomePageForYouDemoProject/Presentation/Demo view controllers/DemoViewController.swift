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

        // setup view
        setScrollView(collectionView)
    }
}

// MARK: - UICollectionViewDataSource

extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get cell reuse identifier for this indexPath
        let identifier = LayoutConfig.cellIdentifier(at: indexPath).rawValue
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopNewsFlowLayoutCell else {
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
}
