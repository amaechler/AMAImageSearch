AMAImageSearch
========================

[![Build Status](https://travis-ci.org/amaechler/AMAImageSearch.svg?branch=master)](https://travis-ci.org/amaechler/AMAImageSearch)

This is a sample project I created for a small iOS development introduction at our company. It demonstrates **UICollectionViews**, makes use of **AFNetworking** and parses **JSON** to display images from the web.

Furthermore, the collection view uses **CHTCollectionViewWaterfallLayout** to get a Pinterest-style view layout.

[![Alt][screenshot1_thumb]][screenshot1]
[![Alt][screenshot2_thumb]][screenshot2]
[![Alt][screenshot3_thumb]][screenshot3]

[screenshot1_thumb]: https://raw.githubusercontent.com/amaechler/AMAImageSearch/master/_Screenshots/bing_facest.png
[screenshot1]: https://raw.githubusercontent.com/amaechler/AMAImageSearch/master/_Screenshots/bing_faces.png
[screenshot2_thumb]: https://raw.githubusercontent.com/amaechler/AMAImageSearch/master/_Screenshots/bing_alpst.png
[screenshot2]: https://raw.githubusercontent.com/amaechler/AMAImageSearch/master/_Screenshots/bing_alps.png
[screenshot3_thumb]: https://raw.githubusercontent.com/amaechler/AMAImageSearch/master/_Screenshots/single_imaget.png
[screenshot3]: https://raw.githubusercontent.com/amaechler/AMAImageSearch/master/_Screenshots/single_image.png

## Cocoapods

The project uses the awesome [Cocoapods](http://cocoapods.org) to fetch the dependencies. Simply run `pod install` to set up the project. The project uses the following pods:

* [AFNetworking 2](https://github.com/AFNetworking/AFNetworking)
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)


## HTTP Clients

* **Instagram** image search
 * Provide your own *Client ID* from your Instagram (developer) account.
* **Google Image Search**
 * Using the Custom Google Search API.
 * Update the code with your *API Key* and *Custom Search Engine ID*.
* **Bing** image search
 * Provide your Bing application *Client secret* to use the search.
* **Unsplash** image listing from Tumblr
 * Provide your Tumblr *API key* to use the listing.

Any feedback is greatly appreciated. All code is freely available under the [Creative Commons Attribution (BY)](http://creativecommons.org/licenses/by/3.0/) License.
