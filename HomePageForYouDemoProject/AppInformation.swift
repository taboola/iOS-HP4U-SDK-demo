//
//  AppInformation.swift
//  HomePageForYouDemoProject (iOS)
//
//  Created by Karen Shaham Palman on 25/05/2022.
//

import UIKit

class AppInformation: UIViewController {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About This Demo"
        infoLabel.text = self.textValue()
    }

    private func textValue() -> String {
        return
    """
    Dear Publisher,

    We're excited to potentially work with you as a design partner, to bring Homepage For You and its benefits to your mobile app (in addition to your desktop and mobile web view platforms).
    To evaluate the possibility of using Taboola Homepage For You in your mobile applications, we prepared the current demo project that you're using.
    
    In addition to the demo project and the enclosed documention, here are the requirements for moving forward:
    - The homepage/section screen developed in native Android/iOS solution (no Flutter/React-native)
    - Integrate Taboola mobile SDK 3
    - The Homepage must use the RecyclerView (Android) / UICollectionView (iOS) native layouts
    - The mobile app content and UI must be identical to the mobile web
    - We do not currently support dynamically changing the layout (elements added or moved in runtime), only done modifications before compiling the application
    - We require a dedicated mobile developer to work with us on a daily/regular basis, preferably using a shared Slack channel.
    
    And here are a few technical points to consider:
    - We prefer working on the iOS and Android app at the same time
    - Currently, in our beta phase, we are focusing on replacing homepage items with ONLY title text, content text, and a thumbnail image. Items with additional functionality, like the share button, video player,etc., will be handled by you For example, if an item include a share icon, the actual share functionality is controlled by you.

    The mobile app should be similar in terms of UI to the mobile web as much as possible to allow control over the SDK features and debugging.
    
    Looking forward to hearing from you, and talking through any questions, feedback, or concerns. Feel free to reach out at android.sdk@taboola.com
    
    Please note that using the demo project is subject to Taboola terms of use, privacy policy and business agreements.
    Please do not share it with any 3rd party. Taboola sends a beacon to itself on usage of this demo.
    
    Taboola Mobile Team
    """
    }
}
