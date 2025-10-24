//
//  HomePageDataApiDataSource.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 17.10.2025.
//

import UIKit
import TaboolaSDK

class HomePageDataApiDataSource: PublisherDataSourceProtocol {
    private(set) var allTopics: [String] = []
    /// All items
    private(set) var regularItems: [PublisherTopic] = []
    private(set) var taboolaItems: [PublisherTopic] = []

    private let requestManager = LocalFileManager()
    private static let contentFile = (name:"HomePageArticlesForDiffable", fileExtension: "json")

    func fetchArticles(completion: @escaping ([PublisherTopic], Error?) -> Void) {
        requestManager.loadLocalItems(file:HomePageDataApiDataSource.contentFile ,
                                      type: [PublisherTopic].self) {[weak self] objects, error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.regularItems = objects ?? []
                self.allTopics = self.regularItems.map { $0.topic }
                completion(self.regularItems, error)
            }
        }
    }

    func saveTaboolaRecommendations(items:[String:[TBLHomePageItem]]) {
        let taboolaTopics = allTopics.compactMap { topic -> PublisherTopic? in
            guard let topicItems = items[topic], !topicItems.isEmpty else { return nil }
            // create PublisherItem from each item
            let publisherItems = topicItems.compactMap(PublisherItem.init(from:))
            return PublisherTopic(topic: topic, items: publisherItems)
        }
        taboolaItems = taboolaTopics
    }

    /// Topic name at given index
    func topicName(at index: Int) -> String? {
        allTopics[index]
    }

    func index(of topic: String) -> Int? {
        allTopics.firstIndex(of: topic)
    }

    func topic(named: String) -> PublisherTopic? {
        topic(named: named, swap: false)
    }

    private func topic(named: String, swap: Bool) -> PublisherTopic? {
        let items = swap ? taboolaItems : regularItems
        return items.filter { $0.topic == named }.first
    }

    private func items(in topicName: String, swap: Bool) -> [PublisherItem] {
        let contentTopic = topic(named: topicName, swap: swap)
        return contentTopic?.items ?? []
    }

    /// Number of items in a topic with a given name.
    /// Controlled by number of publisher's items.
    func numberOfItems(in topic: String) -> Int {
        items(in: topic, swap: false).count // 'false' because number of items depends on publisher's content quantity
    }

    func item(in topic: String, at index: Int) -> PublisherItem? {
        item(in: topic, at: index, shouldReturnSwapItem: false)
    }

    /// Publisher's content item if available
    func item(in topic: String, at index: Int, shouldReturnSwapItem: Bool) -> PublisherItem? {
        let item = shouldReturnSwapItem ? swapItem(in: topic, at: index) : regularItem(in: topic, at: index)
        return item
    }

    /// Returns publisher's item for given topic and index
    func regularItem(in topic: String, at index: Int) -> PublisherItem? {
        let items = items(in: topic, swap: false)
        if index >= items.count {
            return nil
        }
        return items[index]
    }
    
    /// Returns Taboola item for given topic and index
    func swapItem(in topic: String, at index: Int) -> PublisherItem? {
        let items = items(in: topic, swap: true)
        guard let taboolaItemForIndex = items.filter({ $0.indexToInsert == index }).first else {
            return nil
        }
        return taboolaItemForIndex
    }
}

extension HomePageDataApiDataSource {
    func createInitialSnapshot() -> NSDiffableDataSourceSnapshot<PublisherTopic, PublisherItem> {
        var snapshot = NSDiffableDataSourceSnapshot<PublisherTopic, PublisherItem>()
        for topic in regularItems {
            snapshot.appendSections([topic])
            snapshot.appendItems(topic.items, toSection: topic)
        }
        return snapshot
    }
}
