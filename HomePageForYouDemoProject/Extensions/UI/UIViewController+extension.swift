//
//  UIViewController+extension.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.07.2022.
//

import Foundation
import UIKit

extension UIViewController {

    /// Setup navigation bar with a large title label
    /// - Parameters:
    ///   - textColor: Title text color
    ///   - extraAttributes: Extra attributed to be applied to the title text label
    func setupLargeNavigationBarTitle(textColor: UIColor = Constants.Color.accent, extraAttributes: [NSAttributedString.Key : Any] = [:]) {
        let appearance = UINavigationBarAppearance()
        let allAttributes = [.foregroundColor: textColor].merging(extraAttributes, uniquingKeysWith: {$1})
        appearance.largeTitleTextAttributes = allAttributes
        appearance.titleTextAttributes = appearance.largeTitleTextAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}
