//
//  MenuViewController.m
//  AMAImageSearch
//
//  Created by Hsin-yi Berg on 2/3/14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import "MenuViewController.h"
#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "MenuItem.h"
#import "MenuCell.h"

// Strings for creating our data model
#define kBingTitle @"Bing"
#define kGoogleTitle @"Google"
#define kInstagramTitle @"Instagram"
#define kUnsplashTitle @"Unsplash"

#define kBingIconFileName @"bing_search.jpg"
#define kGoogleIconFileName @"google_search.jpg"
#define kInstagramIconFileName @"instagram_search.jpg"
#define kUnsplashIconFileName @"unsplash_search.jpg"

#define kAFBingAPIClient @"AFBingAPIClient"
#define kAFGoogleAPIClient @"AFGoogleAPIClient"
#define kAFInstagramAPIClient @"AFInstagramAPIClient"
#define kAFUnsplashAPIClient @"AFUnsplashAPIClient"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.menuItems = @[[[MenuItem alloc] initWithTitle:kBingTitle
                                          iconFileName:kBingIconFileName
                                             apiClient:kAFBingAPIClient],
                       [[MenuItem alloc] initWithTitle:kGoogleTitle
                                          iconFileName:kGoogleIconFileName
                                             apiClient:kAFGoogleAPIClient],
                       [[MenuItem alloc] initWithTitle:kInstagramTitle
                                          iconFileName:kInstagramIconFileName
                                             apiClient:kAFInstagramAPIClient],
                       [[MenuItem alloc] initWithTitle:kUnsplashTitle
                                          iconFileName:kUnsplashIconFileName
                                             apiClient:kAFUnsplashAPIClient]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell" forIndexPath:indexPath];
    
    MenuItem *menuItem = [self.menuItems objectAtIndex:indexPath.row];
    
    cell.searchMenuTextLabel.text = menuItem.title;
    cell.searchMenuImageView.image = [UIImage imageNamed:menuItem.iconFileName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;

    UIViewController *frontViewController = [revealController frontViewController];
    UIViewController *mainViewController = nil;
    if ([frontViewController isKindOfClass:[UINavigationController class]]) {
        mainViewController = ((UINavigationController *)frontViewController).viewControllers[0];
    }

    NSInteger row = indexPath.row;
    
    // get setlected cell
    MenuItem *menuItem = [self.menuItems objectAtIndex:row];
    // save search provider string to defaults; SearchViewController picks this up when appearing.
    [[NSUserDefaults standardUserDefaults] setObject:menuItem.apiClient forKey:@"search_provider"];
    // reveal the front view controller
    [revealController revealToggleAnimated:YES];
    // trigger image search on the front view controller
    if ([mainViewController conformsToProtocol:@protocol(SearchImageDelegate)]) {
        [(id<SearchImageDelegate>)mainViewController searchImage];
    };
}

@end
