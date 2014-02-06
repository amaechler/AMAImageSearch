//
//  SearchViewController.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSearching.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

- (void)updateTitle;
- (id<ImageSearching>)activeSearchClient;
- (void)loadImagesWithOffset:(int)offset;

@end
