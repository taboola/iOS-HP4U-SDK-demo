//
//  BaseDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 21.08.2022.
//

import UIKit
import TaboolaSDK

class BaseDemoViewController: UIViewController {
    
    @IBOutlet private(set) var collectionView: UICollectionView!

    private typealias HomePageSection = Constants.PublisherContent.HomePageSection
    private var classicPage:TBLClassicPage?
    var classicUnit:TBLClassicUnit?
    var isWithFeed: Bool = false // Supporting cross integration
    
    // init TBLHomePage
    lazy var page = TBLHomePage(settings: createHomePageSettings(), delegate: self)
    
    let datasource: PublisherDataSource = HomePageDataSource()

    // layout configs for different
    enum LayoutConfig: String {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fetch publisher's content
        datasource.fetchArticles {[weak self] items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription ?? ""))")
                return
            }
            self?.collectionView.reloadData()
        }
    }

    private func setupTaboola() {
        page?.targetType = "mix"
        page?.fetchContent()
    }

    func setScrollView(_ scrollView: UIScrollView) {
        // set scrollview object to TBLHomePage
        page?.setScrollView(scrollView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.NavigationSegue.article {
            guard let url = sender as? String, let articleController = segue.destination as? ArticleViewController else { return }
            articleController.setUrl(url)
        }
    }

    private func createHomePageSettings() -> TBLHomePageSettings {
        let builder = TBLHomePageBuilder(pageUrl: "http://blog.taboola.com",
                                         sectionNames: [HomePageSection.health.rawValue, HomePageSection.sport.rawValue, HomePageSection.technology.rawValue, HomePageSection.topNews.rawValue])
        guard let settings = builder.build() else {
            preconditionFailure("TBLHomePageSetting must not be nil")
        }
        return settings
    }
}

// MARK: - UICollectionViewDataSource

extension BaseDemoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        datasource.allTopics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        preconditionFailure("Subclasses must override this method!!!")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let topic = datasource.topicName(at: section) else { return 0 }
        if section == datasource.allTopics.count - 1 && isWithFeed {
            return datasource.numberOfItems(in: topic) + 1
        }
        return datasource.numberOfItems(in: topic)
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
    
    func crossIntegrationFetchDidBecomeAvailable() {
        self.classicPage = TBLClassicPage(pageType: "article", pageUrl:"http://www.example.com", delegate: self, scrollView: collectionView)
        self.classicUnit = self.classicPage?.createUnit(withPlacementName: "Feed without video", mode: "thumbs-feed-01")
        self.classicUnit?.fetchContent()
    }
}

extension BaseDemoViewController: TBLClassicPageDelegate {
    
    func classicUnit(_ classicUnit: UIView!, didFailToLoadPlacementName placementName: String!, errorMessage error: String!) {
        print("Placement with name: \(String(describing: placementName)) failed to load with  error: \(error.debugDescription)")
    }
    
    func classicUnit(_ classicUnit: UIView!, didLoadOrResizePlacementName placementName: String!, height: CGFloat, placementType: PlacementType) {
        print("Placement name: \(String(describing: placementName)) has been loaded with height: \(height)")
    }
    
    func classicUnit(_ classicUnit: UIView!, didClickPlacementName placementName: String!, itemId: String!, clickUrl: String!, isOrganic organic: Bool, customData: [AnyHashable : Any]!) -> Bool {
        return true
    }
    
}

