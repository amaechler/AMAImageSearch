//
//  ImageRecord.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageRecord : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;

@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, assign) CGSize thumbnailSize;

@property (nonatomic, strong) NSURL *imageURL;

@end
