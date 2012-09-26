//
//  ThumbCell.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "ThumbCell.h"

@implementation ThumbCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
