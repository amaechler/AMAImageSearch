//
//  AFGoogleAPIClient.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "ImageSearching.h"

@interface AFGoogleAPIClient : AFHTTPClient <ImageSearching>

+ (AFGoogleAPIClient *)sharedClient;

@end
