# iOS-HP4U-SDK-demo

## Preface

This project showcases how to integrate Taboola's SDK on iOS and use its HomePage capabilities.

### Initialization
1. Add Taboola's SDK to your project via one of the following:
  
  **SPM** - https://github.com/taboola/taboola-spm-ios-sdk - (3.8.0)

  **Cocoapods: podfile:** `pod 'TaboolaSDK', ‘3.8.0’`

  **Carthage: cartfile:** `binary "https://taboola-mobile-sdk.s3-us-west-2.amazonaws.com/public/Carthage/TaboolaSDK.json" == 3.8.0`

2. To initialize the Taboola SDK, you need to create a TBLPublisherInfo object that contains your given publisher name and api key.
   It would be best to do this when your application is just starting, preferably in your application's `AppDelegate` class:
    
    `import TaboolaSDK
    let publisherInfo = TBLPublisherInfo.init(publisherName:PUBLISHER_ID)
    publisherInfo.apiKey = API_KEY
    Taboola(publisherInfo: publisherInfo)`
    
### Creating a HomePage Instance
A HomePage object is meant to match a ViewController where the app's first main content screen is presented.

`let homePage = TBLHomePage.init(delegate: self, sourceType:<sourceType>, pageUrl: <pageUrl>,sectionsNames:[sectionsNames])`

The parameters you need to pass in are:
- sourceType: String describes the widget's type (e.g. SourceTypeVideo).
- pageUrl: String describes the website's URL.
- delegate: Sets the listener for Taboola calls.
- sectionsNames: all sections names which this homePage should work with.

> SectionName is the string title of each group of articles separated by categories.

### HomePage Setup





