//
//  Collection+extension.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 09.07.2022.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
