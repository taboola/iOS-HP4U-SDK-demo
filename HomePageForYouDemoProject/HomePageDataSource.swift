//
//  HomePageDataSource.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import Foundation
import UIKit

protocol PublisherDataSource {
    var allTopics: [String] { get }
    func topicName(at index: Int) -> String?

    func numberOfItems(in topic: String) -> Int
    func item(in topic: String, at index: Int) -> PublisherItem?
    func fetchArticles(completion: @escaping ([PublisherTopic], Error?) -> Void)
    func fetchImage(for item: PublisherItem, completion: @escaping (URL, UIImage?, Error?) -> Void)
}

protocol PublisherItemProtocol {
    var title: String { get }
    var description: String { get }
    var imageUrl: URL { get }
    var link: URL { get }
}

struct PublisherTopic: Decodable {
    let topic: String
    var items: [PublisherItem] = []
}

struct PublisherItem: PublisherItemProtocol {
    let title: String
    let description: String
    let imageUrl: URL
    let link: URL
}

extension PublisherItem: Decodable {}

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

    func fetchImage(for item: PublisherItem, completion: @escaping (URL, UIImage?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            var error: Error?
            defer {
                DispatchQueue.main.async {
                    completion(item.imageUrl, image, error)
                }
            }
            // check if already cached
            let key = item.imageUrl.absoluteString
            if let cachedImage: UIImage = self.cachedImages[key] {
                image = cachedImage
                return
            }
            // decode data
            guard let data = try? Data(contentsOf: item.imageUrl) else {
                error = LocalFileManager.FileManagerError.noContents
                return
            }
            guard let decodedImage = UIImage(data: data) else {
                error = LocalFileManager.FileManagerError.failedToDecode
                return
            }
            self.saveImageToCache(decodedImage, url: item.imageUrl)
            image = decodedImage
        }
    }

    private func saveImageToCache(_ image: UIImage, url: URL) {
        DispatchQueue.main.async {
            self.cachedImages[url.absoluteString] = image
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

struct PublisherContentRouter {
    enum HttpMethod: String {
        case get = "GET"
    }

    static var articles: URLRequest {
        let url = URL(string: "https://dl.dropbox.com/s/rp8we43fpxldz06/HomePageArticles.json?dl=1")!
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        return request
    }

    static func image(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        return request
    }
}

class LocalFileManager {
    private let queue = DispatchQueue.global(qos: .background)

    enum FileManagerError: Error {
        case failed
        case noContents
        case notFound
        case failedToDecode
    }

    func loadLocalItems<T:Decodable>(file: (name: String, fileExtension: String), type: T.Type = T.self, completion: @escaping (T?, Error?) -> Void) {
        queue.async {
            // get file path
            guard let path = Bundle.main.path(forResource: file.name, ofType: file.fileExtension) else {
                completion(nil, FileManagerError.notFound)
                return
            }
            // read file
            guard let string = try? String(contentsOfFile: path, encoding: .utf8), let data = string.data(using: .utf8) else {
                completion(nil, FileManagerError.failed)
                return
            }
            // decode
            do {
                let model: T = try data.decode()
                completion(model, nil)
                return
            } catch {
                completion(nil, error)
                return
            }
        }
    }
}

