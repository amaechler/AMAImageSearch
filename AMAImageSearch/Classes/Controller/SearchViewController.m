//
//  SearchViewController.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "SearchViewController.h"

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

#import "ImageRecord.h"
#import "ImageSearching.h"
#import "ImageViewController.h"

#import "AMAImageViewCell.h"


static NSString * const ImageCellIdentifier = @"ImageViewCell";

static const int kColumnCountPortrait = 2;
static const int kColumnCountLandscape = 3;
static const CGFloat kCellEqualSpacing = 15.0f;

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, assign) CGFloat cellWidth;
@property (strong, nonatomic) NSArray *cellColors;

@end


@implementation SearchViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    self.cellColors = @[ [UIColor colorWithRed:166.0f/255.0f green:201.0f/255.0f blue:227.0f/255.0f alpha:1.0],
                         [UIColor colorWithRed:227.0f/255.0f green:192.0f/255.0f blue:166.0f/255.0f alpha:1.0] ];
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
    self.title = [NSClassFromString(searchProviderString) title];;
    
    NSLog(@"Updated search provider to %@", searchProviderString);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.collectionView registerClass:[AMAImageViewCell class] forCellWithReuseIdentifier:ImageCellIdentifier];
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(0, kCellEqualSpacing, 0, kCellEqualSpacing);
    layout.verticalItemSpacing = kCellEqualSpacing;
    //layout.columnCount = kColumnCounting;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update the title of the search engine
    [self updateTitle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];

    [self updateLayout];
}

- (void)updateLayout
{
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    
    layout.columnCount = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) ?
                            kColumnCountPortrait :
                            kColumnCountLandscape;
    layout.itemWidth = (self.collectionView.bounds.size.width - (layout.columnCount + 1) * kCellEqualSpacing) / layout.columnCount;
}


#pragma mark - Notification handlers

- (void)onApplicationWillEnterForeground:(NSNotification *)notification
{
    [self updateTitle];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMAImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier
                                                                       forIndexPath:indexPath];

    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    cell.imageView.backgroundColor = self.cellColors[indexPath.row % [self.cellColors count]];
    [cell.imageView setImageWithURL:imageRecord.thumbnailURL];
    
    // Check if this has been the last item, if so start loading more images...
    if (indexPath.row == [self.images count] - 1) {
        [self loadImagesWithOffset:[self.images count]];
    };
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"ImageViewSegue" sender:imageRecord];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ImageViewSegue"]) {
        NSAssert([sender isKindOfClass:[ImageRecord class]], @"Expected ImageRecord object.");
        ImageRecord *imageRecord = sender;
		
        ImageViewController *imageViewController = segue.destinationViewController;
        
        imageViewController.title = imageRecord.title;
		imageViewController.imageURL = imageRecord.imageURL;
	}
}


#pragma mark - CHTCollectionViewWaterfallLayoutDelagate

- (CGFloat)collectionView:(UICollectionView *)collectionView
    layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
    heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;

    return imageRecord.thumbnailSize.height * (layout.itemWidth / imageRecord.thumbnailSize.width);
}


#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss the keyboard
    [searchBar resignFirstResponder];
    
    [self loadImagesWithOffset:0];
}

- (id<ImageSearching>)activeSearchClient
{
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    id<ImageSearching> sharedClient = [NSClassFromString(searchProviderString) sharedClient];
    NSAssert(sharedClient, @"Invalid class string from settings encountered");
    
    return sharedClient;
}

- (void)loadImagesWithOffset:(int)offset
{
    if (offset == 0) {
        // Clear the images array and refresh the table view so it's empty
        [self.images removeAllObjects];
        [self.collectionView reloadData];
        
        // Show a loading spinner
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[self activeSearchClient] findImagesForQuery:self.searchbar.text withOffset:offset
         success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {
             if (offset == 0) {
                 self.images = [NSMutableArray arrayWithArray:imageArray];
             } else {
                 [self.images addObjectsFromArray:imageArray];
             }
             
             [self.collectionView reloadData];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (offset == 0) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }
             });
         }
         failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
             NSLog(@"An error occured while searching for images, %@", [error description]);
         }
     ];
}

@end
