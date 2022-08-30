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
}
