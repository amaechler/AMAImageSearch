//
//  ImageViewController.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 02.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "ImageViewController.h"

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"


@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@end


#pragma mark -

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.imageURL == nil) {
        return;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Setup the scrollview
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
    
    // Show a loading spinner
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Start loading image
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.imageURL];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak ImageViewController *weakSelf = self;
    
    [self.imageView setImageWithURLRequest:request placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            // Set the image
            weakSelf.imageView.image = image;

            [self updateZoom];
            [self updateConstraints];

            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"An error occured when loading the image, %@", [error description]);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// Update zoom scale and constraints
// It will also animate because willAnimateRotationToInterfaceOrientation
// is called from within an animation block
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    
    [self updateZoom];
    
    // A hack needed for small images to animate properly on orientation change
    if (self.scrollView.zoomScale == 1) {
        self.scrollView.zoomScale = 1.0001;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateConstraints];
}

- (void)updateConstraints
{
    float imageWidth = self.imageView.image.size.width;
    float imageHeight = self.imageView.image.size.height;
    
    float viewWidth = self.view.bounds.size.width;
    float viewHeight = self.view.bounds.size.height;
    
    // center image if it is smaller than screen
    float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
    if (hPadding < 0) hPadding = 0;
    
    float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
    if (vPadding < 0) vPadding = 0;
    
    self.constraintLeft.constant = hPadding;
    self.constraintRight.constant = hPadding;
    
    self.constraintTop.constant = vPadding;
    self.constraintBottom.constant = vPadding;
}

// Zoom to show as much image as possible unless image is smaller than screen
- (void)updateZoom
{
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                        self.view.bounds.size.height / self.imageView.image.size.height);
    
    if (minZoom > 1) {
        minZoom = 1;
    }
    
    self.scrollView.minimumZoomScale = minZoom;
    self.scrollView.zoomScale = minZoom;
}


- (IBAction)shareImage:(UIBarButtonItem *)sender
{
    // Get the image
    UIImage *image = self.imageView.image;
    
    UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[@"", image]
                                          applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}


@end
