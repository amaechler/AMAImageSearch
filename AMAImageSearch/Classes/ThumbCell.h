//
//  ThumbCell.h
//  AMAImageSearch
//
//  Created by Andreas Mächler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageURL;

@end
