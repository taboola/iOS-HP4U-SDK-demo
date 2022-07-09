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
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    let datasource: PublisherDataSource = HomePageDataSource()
    lazy var page = TBLHomePage(delegate: self, sourceType: SourceTypeText, pageUrl: "http://blog.taboola.com", sectionNames: ["life", "industry", "company", "engagement"])

    enum LayoutConfig: String {
        case topNewsCellIdentifier = "topNewsCell"
        case defaultNewsCellIdentifier = "newsCell"
        case topicHeaderViewIdentifier = "topicHeader"

        private static let topNewsIndex = [IndexPath(row: 0, section: 0)]

        static func cellIdentifier(at indexPath: IndexPath) -> LayoutConfig {
            indexPath == IndexPath(row: 0, section: 0) ?
                .topNewsCellIdentifier :
                .defaultNewsCellIdentifier
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        datasource.fetchArticles { items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription ?? ""))")
                return
            }
            self.collectionView .reloadData()
        }
    }

    private func setupNavigationBar() {
        title = "News"
        let appearance = UINavigationBarAppearance()

        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red, .font: Constants.Layout.newsHeaderFont!]
        appearance.titleTextAttributes = appearance.largeTitleTextAttributes
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    private func setupTaboola() {
        page.setScrollView(collectionView)
        page.targetType = "mix"
        page.fetchContent()
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { datasource.allTopics.count }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let topic = datasource.topicName(at: section) else { return 0 }
        return datasource.numberOfItems(in: topic)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = LayoutConfig.cellIdentifier(at: indexPath).rawValue
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopNewsCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let topic = datasource.topicName(at: indexPath.section), let item = datasource.item(in: topic, at: indexPath.row) else { return cell }

        if page.shouldSwapItem(inSection: topic, indexPath: indexPath, parentView: cell, imageView: cell.imageView, titleView: cell.titleLabel, descriptionView: cell.subtitleLabel, additionalViews: nil) {
            cell.isSwapped = true
        } else {
            // fetch image
            datasource.fetchImage(for: item) { url, image, error in
                guard item.imageUrl == url, error == nil else { return }
                cell.imageView.image = image
                cell.widthConstraint.constant = collectionView.frame.width
            }
            cell.isSwapped = false
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.description
        }
        cell.widthConstraint.constant = collectionView.frame.width
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    // MARK: - Section header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LayoutConfig.topicHeaderViewIdentifier.rawValue, for: indexPath) as? TopicHeaderHeaderView else {
                return UICollectionReusableView()
            }
            let title = indexPath.section == 0 ? nil : datasource.topicName(at: indexPath.section)?.capitalized
            headerView.setTitle(title)
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout { }

extension ViewController: TBLHomePageDelegate {
    func onItemClick(_ placementName: String, withItemId itemId: String, withClickUrl clickUrl: String, isOrganic organic: Bool, customData: String) -> Bool {
        true
    }
}

