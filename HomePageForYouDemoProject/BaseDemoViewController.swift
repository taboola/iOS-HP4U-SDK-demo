//
//  BaseDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 21.08.2022.
//

import UIKit
import TaboolaSDK

class BaseDemoViewController: UIViewController {
    var isPreloadEnabled = true
    var isFlowLayout = false
    private lazy var page = TBLHomePage(delegate: self, sourceType: SourceTypeHome, pageUrl: "http://blog.taboola.com", sectionNames: ["health","sport", "technology", "topnews"])

    let datasource: PublisherDataSource = HomePageDataSource()

    private enum LayoutConfig: String {
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
        setupTaboola()
        title = "News"
        setupLargeNavigationBarTitle(extraAttributes: [.font: Constants.Layout.newsHeaderFont])
    }

    private func setupTaboola() {
        page.targetType = "mix"
        if isPreloadEnabled { page.fetchContent() }
    }

    func setScrollView(_ scrollView: UIScrollView) {
        page.setScrollView(scrollView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.NavigationSegue.article {
            guard let url = sender as? String, let articleController = segue.destination as? ArticleViewController else { return }
            articleController.setUrl(url)
        }
    }
}

extension BaseDemoViewController: UICollectionViewDataSource {
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

        guard let topic = datasource.topicName(at: indexPath.section),
              let item = datasource.item(in: topic, at: indexPath.row) else { return cell }

        if page.shouldSwapItem(inSection: topic,
                               indexPath: indexPath,
                               parentView: cell,
                               imageView: cell.imageView,
                               titleView: cell.titleLabel,
                               descriptionView: cell.subtitleLabel,
                               additionalViews: nil) {
            cell.isSwapped = true
        } else {
            cell.imageView.image = UIImage(named: item.imageName) ?? UIImage.placeholder
            cell.isSwapped = false
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.description
        }
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
            let title = indexPath.section == 0 ? nil : datasource.topicName(at: indexPath.section)?.capitalized
            headerView.setTitle(title)
            return headerView
        }
        return UICollectionReusableView()
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        section == 0 ? .zero : CGSize(width: collectionView.frame.width, height: 50)
//    }
}

extension BaseDemoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let topic = datasource.topicName(at: indexPath.section),
                let item = datasource.item(in: topic, at: indexPath.row) else { return }
        performSegue(withIdentifier: "openArticle", sender: item.link.absoluteString)
    }
}

extension BaseDemoViewController: TBLHomePageDelegate {
    func homePageItemDidClick(_ sectionName: String!, itemId: String!, clickUrl: String!, isOrganic: Bool, customData: String!) -> Bool {
        performSegue(withIdentifier: "openArticle", sender: clickUrl)
        // returning false to handle the click in the app
        return false
    }
}
