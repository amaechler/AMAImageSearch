//
//  AMAImageViewCell.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 03.02.14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import "AMAImageViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface AMAImageViewCell ()

@property (strong, readwrite, nonatomic) UIImageView *imageView;

@end


@implementation AMAImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _imageView.layer.cornerRadius = 5.0f;
        
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

@end
