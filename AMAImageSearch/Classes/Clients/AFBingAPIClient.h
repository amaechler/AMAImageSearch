//
//  AFBingAPIClient.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "ImageSearching.h"

@interface AFBingAPIClient : AFHTTPSessionManager <ImageSearching>

+ (AFBingAPIClient *)sharedClient;

@end
