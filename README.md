# iOS-HP4U-SDK-demo

## Preface

This project showcases how to integrate Taboola's SDK on iOS and use its HomePage capabilities.

### Initialization
1. Add Taboola's SDK to your project via one of the following:
  
      **SPM:** 
      
      https://github.com/taboola/taboola-spm-ios-sdk - (3.8.0)

      **Cocoapods: podfile:** 
      
      `pod 'TaboolaSDK', ‘3.8.0’`

      **Carthage: cartfile:** 
      
      `binary "https://taboola-mobile-sdk.s3-us-west-2.amazonaws.com/public/Carthage/TaboolaSDK.json" == 3.8.0`


2. Start with init Taboola:
    ```
    import TaboolaSDK
    ```

3. In order to initialize the Taboola SDK, you need to create a `TBLPublisherInfo` object that contains your given publisher name and API key.
   It would be best to do this when your application is just starting, preferably in your application's `AppDelegate` class:
    
    ```
    let publisherInfo = TBLPublisherInfo.init(publisherName:PUBLISHER_ID)
    publisherInfo.apiKey = API_KEY
    Taboola(publisherInfo: publisherInfo)
    ```
    
### Creating a HomePage Instance
A HomePage object is meant to match a ViewController where the app's first main content screen is presented.

```
let homePage = TBLHomePage.init(delegate: self, sourceType:<sourceType>, pageUrl: <pageUrl>,sectionsNames:[sectionsNames])
```

The parameters you need to pass in are:
- sourceType: String describes the widget's type (e.g. SourceTypeVideo).
- pageUrl: String describes the website's URL.
- delegate: Sets the listener for Taboola calls.
- sectionsNames: all sections names which this homePage should work with.

> SectionName is the string title of each group of articles separated by categories.

### HomePage Setup
1. In order to link the HomePage to the articles you are presenting, call the attach API with your UIScrollView:
  ```
  homePage.scrollView = scrollView
  ```
2. Next, it is advised to call `fetchContent` as soon as you can so that content will be loaded into the HomePage instance:
  ```
  homePage.fetchContent()
  ```
  
### Swap Articles
To swap articles with content from Taboola, call the `shouldSwapItemInSection` function in your `collectionView:cellForItemAtIndexPath:` method to get the swapped item's content. It returns `true` if the item was swapped, `false` if it wasn't.

```
func shouldSwapItem(inSection section: String?, 
                            indexPath: IndexPath?, 
                            parentView: UIView?, 
                            imageView: UIImageView?, 
                            titleView: UILabel?, 
                            descriptionView: UILabel?, 
                            additionalViews: TBLAdditionalViews?) -> Bool
```
The parameters you need to pass in are:

- sectionName: representing section
- indexPath: of the cell
- parentView: is the UICollectionViewCell
- imageView: UI element representing the image of the cell
- titleView: UI element representing the title of the cell
- descriptionView: UI element representing the description of the cell
- additionalView(optional): UI element representing the all other view in the lineView which aren’t mandatory

#### How does the swapping take place?
When you call `shouldSwapItem`, Taboola verifies that this item is allowed to be swapped and validates the fields of the content, then performs a swap with a recommendation.
Taboola will handle the views the publisher desires to swap.
It will validate the fields of the content and the swapped content as well.
After a successful validation - Taboola will swap the publisher’s content with Taboola recommendations, and return a boolean that indicates if the swapping process did occur.

### Additional HomePage functionality
Previous steps are enough for integrating HomePage, this section describes additional methods for HomePage.

Get HomePage status if needed: // True if HomePage is on, False if it isn't 
```homePage.isActive()```

Set a targetType: // According to your account manager (Usually will be "mix") 
```homePage.targetType = "mix"```

Set a unique id for the HomePage instance 
```homePage.unifiedId = "<string>";```

### Callbacks
Listen to `TBLHomePageDelegate`. All functions are optional and do not need to be implemented.

`func homePageStatusDidChange(_ status: Bool)` Triggered when HomePage is being initialized.

`func homePageDidFail(_ error: String?, sectionName: String?)` Triggered while the swapped items are being rendered.

Possible errors:

- "SWAP_FAILED_DUE_TO_MISSING_DATA"
- "FAILED_TO_RETRIEVE_RECOMMENDATION"
- "SWAP_FAILED_DUE_TO_MISSING_RECOMMENDATION"
 
`func homePageItemDidClick(_ sectionName: String?, itemId: String?, clickUrl: String?, isOrganic: Bool, customData: String?) -> Bool` When implemented, it allows the hosting app to decide what to do when intercepting clicks.

# Legal
Using this repository is subject to Taboola’s [terms of service](https://www.taboola.com/policies/platform-terms-of-use), [privacy policy](https://www.taboola.com/policies/privacy-policy), and the non-disclosed/business agreements set by Taboola and you.
Do not share the content of this repository with any third party.
The files in this repository are for demo usage only and should not use in production without Taboola's approval.
