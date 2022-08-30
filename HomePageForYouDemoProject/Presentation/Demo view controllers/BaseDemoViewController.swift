//
//  BaseDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 21.08.2022.
//

import UIKit
import TaboolaSDK

class BaseDemoViewController: UIViewController {
    // init TBLHomePage
    private lazy var page = TBLHomePage(delegate: self,
                                        sourceType: SourceTypeHome,
                                        pageUrl: "http://blog.taboola.com",
                                        sectionNames: ["health","sport", "technology", "topnews"])
    var isPreloadEnabled = true
    var isFlowLayout = false
    let datasource: PublisherDataSource = HomePageDataSource()

    // layout configs for different
    private enum LayoutConfig: String {
        // raw value = cell reuse identifier
        case topNewsCellIdentifier = "topNewsCell"
        case defaultNewsCellIdentifier = "newsCell"
        case topicHeaderViewIdentifier = "topicHeader"

        // indexes for topNews cell
        private static let topNewsIndex = [IndexPath(row: 0, section: 0)]

        /// Reuse identifier for cell at a given IndexPath
        static func cellIdentifier(at indexPath: IndexPath) -> LayoutConfig {
            indexPath == IndexPath(row: 0, section: 0) ?
                .topNewsCellIdentifier :
                .defaultNewsCellIdentifier
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTaboola()
        title = "News"
        setupLargeNavigationBarTitle(extraAttributes: [.font: Constants.Layout.newsHeaderFont])
    }

    private func setupTaboola() {
        page.targetType = "mix"
        if isPreloadEnabled { page.fetchContent() }
    }

    func setScrollView(_ scrollView: UIScrollView) {
        // set scrollview object to TBLHomePage
        page.setScrollView(scrollView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.NavigationSegue.article {
            guard let url = sender as? String, let articleController = segue.destination as? ArticleViewController else { return }
            articleController.setUrl(url)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BaseDemoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { datasource.allTopics.count }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let topic = datasource.topicName(at: section) else { return 0 }
        return datasource.numberOfItems(in: topic)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get cell reuse identifier for this indexPath
        let identifier = LayoutConfig.cellIdentifier(at: indexPath).rawValue
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TopNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        // get topic name and item for this indexPath
        guard let topic = datasource.topicName(at: indexPath.section),
              let item = datasource.item(in: topic, at: indexPath.row) else { return cell }

        // shouldSwapItem(...) returns whether this cell is going to be swapped by Taboola HomePage
        if page.shouldSwapItem(inSection: topic,
                               indexPath: indexPath,
                               parentView: cell,
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
        if isFlowLayout {
            cell.widthConstraint.constant = collectionView.frame.width
        }

        return cell
    }

    // MARK: - Section header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LayoutConfig.topicHeaderViewIdentifier.rawValue, for: indexPath) as? TopicHeaderHeaderView else {
                return UICollectionReusableView()
            }
            // set header title for all but first sections
            let title = indexPath.section == 0 ? nil : datasource.topicName(at: indexPath.section)?.capitalized
            headerView.setTitle(title)
            return headerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension BaseDemoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // pass item's URL to Article view controller
        guard let topic = datasource.topicName(at: indexPath.section),
              let item = datasource.item(in: topic, at: indexPath.row) else { return }
        performSegue(withIdentifier: "openArticle", sender: item.link.absoluteString)
    }
}

// MARK: - TBLHomePageDelegate

extension BaseDemoViewController: TBLHomePageDelegate {
    func homePageItemDidClick(_ sectionName: String!, itemId: String!, clickUrl: String!, isOrganic: Bool, customData: String!) -> Bool {
        // open Article view controller
        performSegue(withIdentifier: "openArticle", sender: clickUrl)
        // returning false to handle the click in the app
        return false
    }
}
