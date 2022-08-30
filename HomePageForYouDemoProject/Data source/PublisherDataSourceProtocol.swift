//
//  PublisherDataSourceProtocol.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation

protocol PublisherItemProtocol: Decodable {
    var title: String { get }
    var description: String { get }
    var imageName: String { get }
    var link: URL { get }
}

protocol PublisherDataSource {
    var allTopics: [String] { get }
    func topicName(at index: Int) -> String?

    func numberOfItems(in topic: String) -> Int
    func item(in topic: String, at index: Int) -> PublisherItem?
    func fetchArticles(completion: @escaping ([PublisherTopic], Error?) -> Void)
}
