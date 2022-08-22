//
//  HomePageDataSource.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import Foundation
import UIKit

class HomePageDataSource: PublisherDataSource {
    
    private var items: [PublisherTopic] = []
    private(set) var allTopics: [String] = []

    private var cachedImages: [String: UIImage] = [:]
    private let requestManager = LocalFileManager()

    func fetchArticles(completion: @escaping ([PublisherTopic], Error?) -> Void) {
        requestManager.loadLocalItems(file: Constants.PublisherContent.contentFile, type: [PublisherTopic].self) { objects, error in
            DispatchQueue.main.async {
                self.items = objects ?? []
                self.allTopics = self.items.map { $0.topic }
                completion(self.items, error)
            }
        }
    }

    func topicName(at index: Int) -> String? {
        allTopics[safe: index]
    }
    
    func item(in topic: String, at index: Int) -> PublisherItem? {
        let articles = items(in: topic)
        return articles[safe: index]
    }

    func numberOfItems(in topic: String) -> Int {
        items(in: topic).count
    }

    private func topic(named: String) -> PublisherTopic? {
        items.filter { $0.topic == named }.first
    }

    private func items(in topicName: String) -> [PublisherItem] {
        let contentTopic = topic(named: topicName)
        return contentTopic?.items ?? []
    }
}
