//
//  PublisherItem.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation
import TaboolaSDK

struct PublisherItem: PublisherItemProtocol {
    /// id used for diffable datasource
    private(set) var id: String
    private(set) var title: String
    private(set) var description: String
    /// Image filename
    private(set) var imageName: String?
    /// Image URL
    private(set) var imageUrl: URL?
    /// Click URL is used only for publisher's items. Clicks on Taboola items are handled by TaboolaSDK.
    private(set) var clickUrl: URL?
    
    /// Index where to put the item (for taboola items)
    var indexToInsert: Int?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageName
        case imageUrl
        case clickUrl = "link"
    }

    init(id: String,
         title: String,
         description: String,
         imageName: String? = nil,
         imageUrl: URL? = nil,
         clickUrl: URL? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.clickUrl = clickUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        self.imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
        self.clickUrl = try container.decode(URL.self, forKey: .clickUrl)
    }


    // Hashable uses id only
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PublisherItem, rhs: PublisherItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PublisherItem {
    static var mockItem: PublisherItem {
        PublisherItem(id: "mock_0",
                      title: "Mock Title",
                      description: "Mock Description",
                      imageName: "health_0",
                      clickUrl: URL(string: "https://www.taboola.com")!)
    }

    static var mockItemWithImageUrl: PublisherItem {
        PublisherItem(id: "mock_0",
                      title: "Mock Title",
                      description: "Mock Description",
                      imageUrl: URL(string:"https://www.taboola.com//wp-content/uploads/2024/05/lgo-taboola_logo-2024-blue_logo.png")!,
                      clickUrl: URL(string: "https://www.taboola.com")!)
    }

    init(from homePageItem: TBLHomePageItem) {
        self.init(
            id: homePageItem.identifier,
            title: homePageItem.title,
            description: homePageItem.description,
            imageUrl: URL(string: homePageItem.imageUrl)
        )
        self.indexToInsert = homePageItem.swapIndex
    }
}
