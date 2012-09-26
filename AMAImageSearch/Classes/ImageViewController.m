//
//  ImageViewController.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 02.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "ImageViewController.h"

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AutoCenterScrollView.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet AutoCenterScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end


#pragma mark -

@implementation ImageViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"%@", self);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.imageURL == nil)
        return;
    
    // Setup the scrollview
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setCanCancelContentTouches:NO];
    self.scrollView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.imageView];

    self.scrollView.centeredView = self.imageView;
    
    // Show a loading spinner
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Start loading image
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.imageURL];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self.imageView setImageWithURLRequest:request placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            // Adjust image view
            self.imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            
            [self.scrollView setContentSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];
            [self.scrollView setScrollEnabled:YES];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"An error occured when loading the image, %@", [error description]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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

@end
