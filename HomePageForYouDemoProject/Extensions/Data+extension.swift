//
//  Data+extension.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 09.07.2022.
//

import Foundation
import UIKit

extension Data {
    func decode<T:Decodable>(as: T.Type = T.self) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }

    func decode<T:UIImage>() throws -> T {
        guard let image = UIImage(data: self) as? T else { throw LocalFileManager.FileManagerError.notFound }
        return image
    }
}
