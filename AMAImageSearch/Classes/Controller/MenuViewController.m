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


@interface MenuViewController ()

@property (strong, nonatomic) NSArray *searchProviders;

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

    self.tableView.alwaysBounceVertical = NO;
    
    self.searchProviders = @[ @"AFBingAPIClient",
                              @"AFGoogleAPIClient",
                              @"AFInstagramAPIClient",
                              @"AFUnsplashAPIClient" ];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource delegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Search Providers";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchProviders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchProviderCell"];
    
    NSString *searchProviderString = self.searchProviders[indexPath.row];
    cell.textLabel.text = [NSClassFromString(searchProviderString) title];
    cell.imageView.image = [UIImage imageNamed:searchProviderString];
    if (cell.imageView.image == nil) {
        NSLog(@"No image icon for %@ found.", searchProviderString);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the parent reveal controller
    SWRevealViewController *revealController = self.revealViewController;

    // Get the search view controller (behind the navigation controller)
    NSAssert([self.revealViewController.frontViewController isKindOfClass:[UINavigationController class]], @"");
    SearchViewController *searchController = ((UINavigationController *)self.revealViewController.frontViewController).viewControllers[0];

    // Save search provider string to defaults
    [[NSUserDefaults standardUserDefaults] setObject:self.searchProviders[indexPath.row] forKey:@"search_provider"];
    [searchController updateTitle];
    
    [revealController revealToggleAnimated:YES];

    // trigger image search on the front view controller
    [searchController loadImagesWithOffset:0];
}

@end
