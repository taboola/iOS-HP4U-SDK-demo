//
//  PublisherItem.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation

struct PublisherItem: PublisherItemProtocol {
    let title: String
    let description: String
    /// Image filename
    let imageName: String
    /// Click URL
    let link: URL
}
