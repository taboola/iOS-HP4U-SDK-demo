//
//  UIView+extension.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 06.07.2022.
//

import Foundation
import UIKit

extension UIView {
    func fadeInOut(finished: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: { self.alpha = 0 }, completion: { _ in self.alpha = 1 })
    }
}
