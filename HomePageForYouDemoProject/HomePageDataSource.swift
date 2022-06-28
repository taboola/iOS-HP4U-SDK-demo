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
    func fetchArticles(completion: @escaping ([String: [PublisherItem]], Error?) -> Void)
    func fetchImage(for item: PublisherItem, completion: @escaping (URL, UIImage?, Error?) -> Void)
}

protocol PublisherItemProtocol {
    var title: String { get }
    var description: String { get }
    var imageUrl: URL { get }
    var link: URL { get }
}

struct PublisherItem: PublisherItemProtocol {
    let title: String
    let description: String
    let imageUrl: URL
    let link: URL
}

extension PublisherItem: Decodable {}

class HomePageDataSource: PublisherDataSource {
    var items: [String: [PublisherItem]] = [:]
    private var cachedImages: [String: UIImage] = [:]
    private let requestManager = RequestManager()

    func fetchArticles(completion: @escaping ([String: [PublisherItem]], Error?) -> Void) {
        requestManager.runRequest(PublisherContentRouter.articles, type: [String: [PublisherItem]].self) { objects, error in
            self.items = objects ?? [:]
            DispatchQueue.main.async {
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
            if let cachedImage: UIImage = self.cachedImages[item.imageUrl.absoluteString] {
                image = cachedImage
                return
            }
            // decode data
            guard let data = try? Data(contentsOf: item.imageUrl) else {
                error = RequestManager.RequestError.noResponseBody
                return
            }
            guard let decodedImage = UIImage(data: data) else {
                error = RequestManager.RequestError.failedToDecode
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

    var allTopics: [String] { [String] (items.keys) }

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

    private func items(in topic: String) -> [PublisherItem] {
        return items[topic] ?? []
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

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class RequestManager {
    private let queue = DispatchQueue.global(qos: .background)
    enum RequestError: Error {
        case failed
        case badStatusCode(Int)
        case noResponseBody
        case failedToDecode
    }

    func runRequest<T:Decodable>(_ request: URLRequest, type: T.Type = T.self, completion: @escaping (T?, Error?) -> Void) {
        queue.async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                // check response object
                do {
                    try self.verifyResponse(response)
                } catch {
                    completion(nil, error)
                }
                // check body
                guard let data = data else {
                    completion(nil, RequestError.noResponseBody)
                    return
                }
                // decode body
                do {
                    let model: T = try data.decode()
                    completion(model, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }

//    func loadImage(url: URL, completion)

    private func verifyResponse(_ response: URLResponse?) throws {
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.failed
        }
        guard 200...300 ~= response.statusCode else {
            throw RequestError.badStatusCode(response.statusCode)
        }
    }
}

extension Data {
    func decode<T:Decodable>(as: T.Type = T.self) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }

    func decode<T:UIImage>() throws -> T {
        guard let image = UIImage(data: self) as? T else { throw RequestManager.RequestError.noResponseBody }
        return image
    }
}
