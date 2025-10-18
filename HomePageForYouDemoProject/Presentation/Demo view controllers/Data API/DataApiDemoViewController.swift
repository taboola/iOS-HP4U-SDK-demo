//
//  DataApiDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 18.10.2025.
//

import UIKit

class DataApiDemoViewController: BaseDemoViewController {

    @IBOutlet private var collectionLayout: UICollectionViewFlowLayout! {
        didSet { collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize }
    }

    let imageLoader = ImageLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        isWithFeed = false
        datasource = HomePageDataApiDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setScrollView(collectionView)
    }

    private func isClassicUnitCellFor(_ indexPath:IndexPath) -> Bool {
        return indexPath.section == datasource.allTopics.count - 1 && indexPath.item ==  datasource.allTopics.count
    }

    private func fetchPublisherContent() {
        datasource.fetchArticles {[weak self] items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription ?? ""))")
                return
            }
            // update datasource
            self?.collectionView.reloadData()
        }
    }
}

extension DataApiDemoViewController {

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
        guard let page, let topicName = datasource.topicName(at: indexPath.section) else { return cell }
        let shouldSwapItem = page.shouldSwapItem(inSection: topicName, indexPath: indexPath)
        if let item = datasource.item(in: topicName, at: indexPath.item, shouldReturnSwapItem: shouldSwapItem) {
            cell.isSwapped = shouldSwapItem
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.description
            // image
            if let imageName = item.imageName {
                cell.imageView.image = UIImage(named: imageName) ?? UIImage.placeholder
            } else if let imageUrl = item.imageUrl {
                // save for URL check later
                cell.imageUrl = imageUrl
                imageLoader.load(imageUrl) { image, requestUrl in
                    guard requestUrl == cell.imageUrl else { return }
                    guard let image else {
                        cell.imageView.image = UIImage.placeholder
                        return
                    }
                    cell.imageView.image = image
                    cell.imageUrl = nil
                }
            }
            // report successful swap
            page.reportSwapSuccess(ofItem: item.id, inSection: topicName, indexPath: indexPath, parentView: cell)
        }
        // autolayout adjustment for cell width
        cell.widthConstraint.constant = collectionView.frame.width
        return cell
    }

    func reloadItems(at positions:[String: [NSNumber]]) {
        collectionView.performBatchUpdates {
            for (topicName, indexes) in positions {
                guard let sectionIndex = indexOfSection(named: topicName) else { continue }
                let items = indexes.compactMap {
                    IndexPath(item: $0.intValue, section: sectionIndex)
                }
                collectionView.reloadItems(at: items)
            }
        }
    }
}

extension DataApiDemoViewController {
    func homePageStatusDidChange(_ status: Bool) {
        if let page, status {
            page.fetchContent {[weak self] status, fetchDatasource in
                if let self, status {
                    self.datasource.saveTaboolaRecommendations(items: fetchDatasource.items)
                    self.reloadItems(at: fetchDatasource.allSwapIndexes())
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DataApiDemoViewController: UICollectionViewDelegateFlowLayout {
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

final class ImageLoader {
    private let cache = NSCache<NSURL, UIImage>()
    
    /// Loads an image from remote URL.
    ///
    /// Completion is called on main queue
    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage?, URL) -> Void) -> URLSessionDataTask? {
        let key = url as NSURL
        if let cached = cache.object(forKey: key) {
            DispatchQueue.main.async {
                completion(cached, url)
            }
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            var image: UIImage? = nil
            if let data = data { image = UIImage(data: data) }
            if let image { self?.cache.setObject(image, forKey: key) }
            DispatchQueue.main.async {
                completion(image, url)
            }
        }
        task.resume()
        return task
    }
}
