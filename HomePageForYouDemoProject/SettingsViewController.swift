//
//  SettingsViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 23.06.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showLaunchScreen()
    }

    private func showLaunchScreen() {
        navigationController?.isNavigationBarHidden = true
        let splash = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SplashViewController")
        self.navigationController?.show(splash, sender: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.isNavigationBarHidden = false
        }
    }
}
