//
//  ViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import UIKit
import TaboolaSDK

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let datasource: PublisherDataSource = HomePageDataSource()
    lazy var page = TBLHomePage(delegate: self, sourceType: SourceTypeText, pageUrl: "http://blog.taboola.com")

    struct Constants {
        static let topNewsCellIdentifier = "topNewsCell"
        static let topicHeaderViewIdentifier = "topicHeader"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.fetchArticles { items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription)")
                return
            }
            self.collectionView .reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { datasource.allTopics.count }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let topic = datasource.topicName(at: section) else { return 0 }
        return datasource.numberOfItems(in: topic)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.topNewsCellIdentifier, for: indexPath) as? TopNewsCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let topic = datasource.topicName(at: indexPath.section), let item = datasource.item(in: topic, at: indexPath.row) {
//            cell.imageView.image = item.image
            cell.titleLabel.text = item.title
        }
        return cell
    }

    // MARK: - Section header

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.topicHeaderViewIdentifier, for: indexPath) as? TopicHeaderHeaderView else {
                return UICollectionReusableView()
            }
            headerView.setTitle(datasource.topicName(at: indexPath.section))
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}


extension ViewController: TBLHomePageDelegate {
    func onItemClick(_ placementName: String, withItemId itemId: String, withClickUrl clickUrl: String, isOrganic organic: Bool, customData: String) -> Bool {
        true
    }
}

