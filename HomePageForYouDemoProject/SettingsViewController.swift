//
//  SettingsViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 23.06.2022.
//

import UIKit
import TaboolaSDK

class SettingsViewController: UIViewController {
    // a flag to report usage only once per session
    private var hasReportedDemoUsage = false
    private var tableViewController: SettingsTableViewController {
        guard let controller = children.first as? SettingsTableViewController else { preconditionFailure("Wrong embedded viewcontroller") }
        return controller
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo Settings"
        setupLargeNavigationBarTitle()
        showLaunchScreen()
        tableViewController.setCredentials(publisher: Constants.DefaultPublisher.name, apikey: Constants.DefaultPublisher.apiKey)
    }

    private func showLaunchScreen() {
        navigationController?.isNavigationBarHidden = true
        let splash = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SplashViewController")
        self.navigationController?.show(splash, sender: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.LaunchScreen.onScreenTime) {
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    // MARK: - IBAction
    @IBAction func launchDemoButtonPressed(_ sender: Any) {
        if tableViewController.publisherCredentials() == nil {
            showAlert(with: "Error", subtitle: "Please fill in all required fields")
        } else if !hasReportedDemoUsage {
            // report app usage
            Taboola.reportTBLMobileEvent([:], eventType: Constants.UsageReporting.eventType)
            // change the flag to report only once
            hasReportedDemoUsage = true
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
        if identifier == Constants.NavigationSegue.demo {
            return tableViewController.publisherCredentials() != nil
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.NavigationSegue.demo, let account = tableViewController.publisherCredentials() {
            if let destination = segue.destination as? ViewController {
                destination.isPreloadEnabled = tableViewController.isPreloadSelected()
            }
            let publisher = TBLPublisherInfo(publisherName: account.publisher)
            publisher.apiKey = account.apiKey
            Taboola.initWith(publisher)
        }
    }
}
