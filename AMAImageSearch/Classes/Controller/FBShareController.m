//
//  FBShareController.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 07.02.14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import "FBShareController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation FBShareController

+ (void)shareImageURLOnFacebook:(NSURL *)imageURL fromViewController:(UIViewController *)viewController
{
    // Get the image
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];

    // Build the image content for FB sharing
    FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:NO];
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:viewController withContent:content delegate:nil];

    [FBSDKAppEvents logEvent:@"shareImageURLOnFacebook"];
}

@end
