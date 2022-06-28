//
//  SettingsTableViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 28.06.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet private weak var publisherTextfield: UITextField!
    @IBOutlet private weak var apiKeyTextfield: UITextField!

    @IBOutlet private weak var preloadSwitch: UISwitch!
    @IBOutlet private weak var lazyLoadSwitch: UISwitch!

    @IBAction private func loadingSwitchStateDidChange(_ sender: UISwitch) {
        let newState = sender.isOn
        if sender == preloadSwitch {
            preloadSwitch.isOn = newState
            lazyLoadSwitch.isOn = !newState
        } else if sender == lazyLoadSwitch {
            lazyLoadSwitch.isOn = newState
            preloadSwitch.isOn = !newState
        }
    }

    func setCredentials(publisher: String, apikey: String) {
        publisherTextfield.text = publisher
        apiKeyTextfield.text = apikey
    }

    func publisherCredentials() -> (publisher:String, apiKey:String)? {
        guard let publisher = publisherTextfield.text, !publisher.isEmpty,
              let key = apiKeyTextfield.text, !key.isEmpty else { return nil }
        return (publisher, key)
    }

    func isPreloadSelected() -> Bool {
        preloadSwitch.isOn
    }
}
