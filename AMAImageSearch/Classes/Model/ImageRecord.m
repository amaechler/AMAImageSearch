//
//  ImageRecord.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "ImageRecord.h"
#import "AppDelegate.h"

@implementation ImageRecord

- (id)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _details = @"";
    }

    return self;
}

@end
