//
//  PublisherTopic.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation

class PublisherTopic: Decodable, Hashable {

    /// Topic name
    let topic: String
    var items: [PublisherItem] = []
    private(set) var id:UUID = UUID()

    init(topic: String) {
        self.topic = topic
    }

    init(topic: String, items:[PublisherItem]) {
        self.topic = topic
        self.items = items
    }

    private enum CodingKeys: String, CodingKey {
        case topic
        case items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.items = try container.decode([PublisherItem].self, forKey: .items)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(topic)
    }

    static func == (lhs: PublisherTopic, rhs: PublisherTopic) -> Bool {
        lhs.topic == rhs.topic
    }
}
