//
//  ImageViewController.h
//  AMAImageSearch
//
//  Created by Andreas Mächler on 02.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SceneViewController;

@interface ImageViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSURL *imageURL;

@end
