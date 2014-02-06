//
//  ImageSearching.h
//  AMAImageSearch
//
//  Created by Andreas Maechler on 01.10.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ISSuccessBlock)(NSURLSessionDataTask *, NSArray *);
typedef void (^ISFailureBlock)(NSURLSessionDataTask *, NSError *);

@protocol ImageSearching <NSObject>
@required

+ (NSString *)title;

+ (id)sharedClient;
- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure;

@end
