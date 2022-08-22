//
//  LocalFileManager.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 22.08.2022.
//

import Foundation

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
