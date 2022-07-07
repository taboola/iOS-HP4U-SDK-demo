//
//  UIViewController+extension.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.07.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func setupLargeNavigationBarTitle(textColor: UIColor = Constants.Color.accent) {
        let appearance = UINavigationBarAppearance()

        appearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        appearance.titleTextAttributes = appearance.largeTitleTextAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}
