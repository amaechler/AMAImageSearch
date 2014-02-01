//
//  AFUnsplashAPIClient.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "ImageSearching.h"

@interface AFUnsplashAPIClient : AFHTTPSessionManager <ImageSearching>

+ (AFUnsplashAPIClient *)sharedClient;

@end
