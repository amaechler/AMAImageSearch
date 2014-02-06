//
//  MenuItem.h
//  AMAImageSearch
//
//  Created by Hsin-yi Berg on 2/4/14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconFileName;
@property (nonatomic, strong) NSString *apiClient;

- initWithTitle:(NSString *)title
   iconFileName:(NSString *)iconFileName
      apiClient:(NSString *)apiClient;

@end
