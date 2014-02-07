//
//  AppDelegate.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookSDK.h"
#import "AMAHelperUtils.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register the preference defaults early.
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"search_provider": @"AFGoogleAPIClient" }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Asks the delegate to open a resource identified by URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication
        fallbackHandler:^(FBAppCall *call) {
            NSLog(@"Unhandled deep link: %@", url);
            
            // Parse the incoming URL to look for a target_url parameter
            NSString *query = [url fragment];
            if (!query) {
                query = [url query];
            }
            
            NSDictionary *params = [AMAHelperUtils parseURLParams:query];
            // Check if target URL exists
            NSString *targetURLString = [params valueForKey:@"target_url"];
            if (targetURLString) {
                // Show the incoming link in an alert
                // Your code to direct the user to the appropriate flow within your app goes here
                [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                            message:targetURLString
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }];
    
    return urlWasHandled;
}

@end
