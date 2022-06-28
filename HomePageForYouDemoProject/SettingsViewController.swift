//
//  SettingsViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 23.06.2022.
//

import UIKit
import TaboolaSDK

class SettingsViewController: UIViewController {
    private enum NavigationSegue: String {
        case demo = "openDemo"
        case info = "openInfo"
    }

    private var tableViewController: SettingsTableViewController {
        guard let controller = children.first as? SettingsTableViewController else { preconditionFailure("Wrong embedded viewcontroller") }
        return controller
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        showLaunchScreen()
        tableViewController.setCredentials(publisher: Constants.DefaultPublisher.name, apikey: Constants.DefaultPublisher.apiKey)
    }

    private func setupNavigationBar() {
        title = "Demo Settings"
        let appearance = UINavigationBarAppearance()

        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        appearance.titleTextAttributes = appearance.largeTitleTextAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    private func showLaunchScreen() {
        navigationController?.isNavigationBarHidden = true
        let splash = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SplashViewController")
        self.navigationController?.show(splash, sender: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // TODO: change delay
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    // MARK: - IBAction
    @IBAction func launchDemoButtonPressed(_ sender: Any) {
        if tableViewController.publisherCredentials() == nil {
            showAlert(with: "Error", subtitle: "Please fill in all required fields")
        }
    }
    @IBAction func demoInfoButtonPressed(_ sender: Any) { }

    private func showAlert(with title: String, subtitle: String?) {
        let alertCtrl = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertCtrl.addAction(okAction)
        present(alertCtrl, animated: true)
    }
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == NavigationSegue.demo.rawValue {
            return tableViewController.publisherCredentials() != nil
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == NavigationSegue.demo.rawValue, let account = tableViewController.publisherCredentials() {
            let publisher = TBLPublisherInfo(publisherName: account.publisher)
            publisher.apiKey = account.apiKey
            Taboola.initWith(publisher)
        }
    }
}
