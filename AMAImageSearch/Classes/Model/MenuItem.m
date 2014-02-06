//
//  MenuItem.m
//  AMAImageSearch
//
//  Created by Hsin-yi Berg on 2/4/14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- initWithTitle:(NSString *)title
   iconFileName:(NSString *)iconFileName
      apiClient:(NSString *)apiClient
{
    self = [super init];
    if (self) {
        _title = title;
        _iconFileName = iconFileName;
        _apiClient = apiClient;
    }
    
    return self;
}

@end
