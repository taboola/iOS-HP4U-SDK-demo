//
//  UIView+extension.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 06.07.2022.
//

import Foundation
import UIKit

extension UIView {
    func fadeInOut(duration: Double = 1.5) {
        UIView.animate(withDuration: duration, delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: { self.alpha = 0.3 }, completion: { _ in self.alpha = 1 })
    }
}
