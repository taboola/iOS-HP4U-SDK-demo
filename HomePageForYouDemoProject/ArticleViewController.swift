//
//  ArticleViewController.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 06.07.2022.
//

import UIKit

class ArticleViewController: UIViewController {
    private var urlString: String?
    @IBOutlet private weak var urlLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        urlLabel.text = urlString
    }

    func setUrl(_ text: String?) {
        urlString = text
    }
}
