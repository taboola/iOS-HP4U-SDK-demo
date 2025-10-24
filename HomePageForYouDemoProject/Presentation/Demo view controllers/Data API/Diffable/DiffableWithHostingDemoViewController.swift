//
//  DiffableWithHostingDemoViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.10.2025.
//

import UIKit

/// UICollectionView with UIDiffableDatasource with cells with UIHostingConfiguration (SwiftUI inside UIKit)
class DiffableWithHostingDemoViewController: BaseDemoViewController {
    private var dataSource: UICollectionViewDiffableDataSource<PublisherTopic, PublisherItem>!
    var data: HomePageDataApiDataSource  = HomePageDataApiDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        isWithFeed = false
        // setup collectionview
        registerCells()
        setupDataSourceCellProvider()
        setupHeaderView()
        collectionView.delegate = self
        // fetch publisher's content
        fetchPublisherContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #unavailable(iOS 16.0) {
            let alertController = UIAlertController(
                title: "This screen is not supported",
                message: "UIHostingConfiguration is not supported on iOS<16.0",
                preferredStyle: .alert
            )
            let popAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(popAction)
            self.present(alertController, animated: true)
            return
        }
        setScrollView(collectionView)
    }

    func registerCells() {
        collectionView.register(HomePageCollectionHostingCellView.self,
                                forCellWithReuseIdentifier: "HomePageCollectionHostingCellView")
    }

    override func setupTaboola() {
        page?.targetType = "mix"
    }

    private func fetchPublisherContent() {
        data.fetchArticles {[weak self] items, error in
            guard error == nil else {
                print("Error fetching articles: \(error?.localizedDescription ?? ""))")
                return
            }
            // update datasource
            guard let self else { return }
            let snapshot = self.data.createInitialSnapshot()
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private func setupDataSourceCellProvider() {
        guard let collectionView = self.collectionView, let page = self.page else { return }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: {[weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionHostingCellView", for: indexPath) as? HomePageCollectionHostingCellView else { return UICollectionViewCell() }
            guard let topic = data.topicName(at: indexPath.section) else { return cell }

            let shouldUseTaboola = page.shouldSwapItem(inSection: topic, indexPath: indexPath)
            let item = data.item(in: topic, at: indexPath.row, shouldReturnSwapItem: shouldUseTaboola)
            cell.item = item
            if shouldUseTaboola, var item {
                item.indexToInsert = indexPath.row
                page.reportSwapSuccess(ofItem: item.id, inSection: topic, indexPath: indexPath, parentView: cell)
                // alternatively report failure if there is a swap item but still you can't swap the item due to your internal logic
                // page.reportSwapFailure(ofItem: item.id, reason: "failed_to_swap", inSection: topic, indexPath: indexPath, parentView: cell)
            }

            return cell
        })
    }

    private func setupHeaderView() {
        dataSource.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self, kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "topicHeader",
                for: indexPath) as! TopicHeaderHeaderView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            header.setTitle(section.topic.capitalized)
            return header
        }
    }

    func reloadDiffableItems(at positions:[String: [NSNumber]]) {
        var snapshot = dataSource.snapshot()
        for (topicName, indexes) in positions {
            guard let topic = data.topic(named: topicName),
                  let sectionIndex = dataSource.index(for: topic) else { break }
            let items = indexes.compactMap {
                let indexPath = IndexPath(item: $0.intValue, section: sectionIndex)
                return dataSource.itemIdentifier(for: indexPath)
            }
            snapshot.reloadItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension DiffableWithHostingDemoViewController {
    func homePageStatusDidChange(_ status: Bool) {
        if let page, status {
            page.fetchContent {[weak self] status, fetchDatasource in
                if let self, status {
                    self.data.saveTaboolaRecommendations(items: fetchDatasource.items)
                    self.reloadDiffableItems(at: fetchDatasource.allSwapIndexes())
                }
            } failureCompletion: { error in
                print("Error fetching home page: \(error.localizedDescription)")
            }
        }
    }
}

extension DiffableWithHostingDemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        section == 0 ? .zero : CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width:width, height: 140)
    }
}
