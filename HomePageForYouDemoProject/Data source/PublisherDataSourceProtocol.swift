//
//  PublisherDataSourceProtocol.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation
import TaboolaSDK

protocol PublisherItemProtocol: Hashable, Decodable {
    var id: String { get }
    var title: String { get }
    var description: String { get }
    var imageName: String? { get }
    var clickUrl: URL? { get }

    // Used for Taboola recommendation items
    var imageUrl: URL? { get }
    var indexToInsert: Int? { get }
}

protocol PublisherDataSourceProtocol {
    // MARK: Common
    /// Fetch publisher's (mock) items
    func fetchArticles(completion: @escaping ([PublisherTopic], Error?) -> Void)

    var allTopics: [String] { get }
    func topicName(at index: Int) -> String?

    func topic(named: String) -> PublisherTopic?
    /// Returns number of items in given topic (section)
    func numberOfItems(in topic: String) -> Int

    // MARK: Swapping
    // Returns publisher's item for given topic and index
    func item(in topic: String, at index: Int) -> PublisherItem? // used for Swapping solution

    // MARK: Data API
    /// Stores recommendations from TaboolaSDK into your app datasource
    func saveTaboolaRecommendations(items:[String:[TBLHomePageItem]])
    // Returns publisher's or (if available) Taboola swap item for given topic and index based on `swapItem` parameter.
    func item(in topic: String, at index: Int, shouldReturnSwapItem: Bool) -> PublisherItem? // used only for Data API solution

}

