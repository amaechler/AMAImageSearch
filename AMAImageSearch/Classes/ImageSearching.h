//
//  ImageSearchProtocol.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ISSuccessBlock)(AFHTTPRequestOperation *operation, NSArray *images);
typedef void (^ISFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@protocol ImageSearching <NSObject>
@required

+ (id)sharedClient;
- (void)findImagesForQuery:(NSString *)query success:(ISSuccessBlock)success failure:(ISFailureBlock)failure;

@end
