//
//  SearchViewController.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "SearchViewController.h"

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

#import "ImageRecord.h"
#import "ThumbCell.h"
#import "ImageSearching.h"
#import "ImageViewController.h"


@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;

@property (nonatomic, strong) NSMutableArray *images;

@end


@implementation SearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)updateTitle
{
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    self.title = searchProviderString;
    
    NSLog(@"Updated search provider to %@", searchProviderString);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self updateTitle];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Notification handlers

- (void)onApplicationWillEnterForeground:(NSNotification *)notification
{
    [self updateTitle];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.images count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ThumbCell";
	ThumbCell *cell = (ThumbCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ThumbCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    cell.imageTitle.text = imageRecord.title;
    cell.imageURL.text = imageRecord.details;

    [cell.thumbnail setImageWithURL:imageRecord.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder"]];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CellSegue"]) {
		ImageViewController *imageViewController = segue.destinationViewController;

        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ImageRecord *imageRecord = [self.images objectAtIndex:path.row];

        imageViewController.title = imageRecord.title;
		imageViewController.imageURL = imageRecord.imageURL;
	}
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss the keyboard
    [searchBar resignFirstResponder];
    
    [self loadImages];
}

- (void)loadImages
{
    // Clear the images array and refresh the table view so it's empty
    [self.images removeAllObjects];
    [self.tableView reloadData];
    
    // Show a loading spinner
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    id<ImageSearching> sharedClient = [NSClassFromString(searchProviderString) sharedClient];
    NSAssert(sharedClient, @"Invalid class string from settings encountered");
    
    NSLog(@"Using class %@ for searching images...", searchProviderString);
    [sharedClient findImagesForQuery:self.searchbar.text
         success:^(AFHTTPRequestOperation *operation, NSArray *imageArray) {
             self.images = [NSMutableArray arrayWithArray:imageArray];
             [self.tableView reloadData];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"An error occured while searching for images, %@", [error description]);
         }
     ];
}

@end
