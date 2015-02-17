//
//  FBShareController.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 07.02.14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import "FBShareController.h"

#import "FacebookSDK.h"
#import "AMAHelperUtils.h"

#define kFacebookShareURL @"https://developers.facebook.com/docs/ios/share/"
#define kFacebookShareName @"AMAImageSearch"
#define kFacebookShareCaption @"I would like to share this photo with you... What do you think?"
#define kFacebookShareDescription @"Search and Share images using AMAImageSearch"


@implementation FBShareController

+ (void)shareImageURLOnFacebook:(NSURL *)imageURL
{
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = imageURL;
    params.name = kFacebookShareName;
    params.caption = kFacebookShareCaption;
    params.picture = imageURL;
    // params.description = kFacebookShareDescription;
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       kFacebookShareName, @"name",
                                       kFacebookShareCaption, @"caption",
                                       kFacebookShareDescription, @"description",
                                       imageURL.absoluteString, @"link",
                                       imageURL.absoluteString, @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params
            handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                if (error) {
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                    NSLog(@"Error publishing story: %@", error.description);
                } else {
                    if (result == FBWebDialogResultDialogNotCompleted) {
                        // User canceled.
                        NSLog(@"User cancelled.");
                    } else {
                        // Handle the publish feed callback
                        NSDictionary *urlParams = [AMAHelperUtils parseURLParams:[resultURL query]];
                        
                        if (![urlParams valueForKey:@"post_id"]) {
                            // User canceled.
                            NSLog(@"User cancelled.");
                            
                        } else {
                            // User clicked the Share button
                            NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                            NSLog(@"result %@", result);
                        }
                    }
                }
            }];
    }
}

@end
