//
//  PublisherTopic.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation

struct PublisherTopic: Decodable {
    let topic: String
    var items: [PublisherItem] = []
}
