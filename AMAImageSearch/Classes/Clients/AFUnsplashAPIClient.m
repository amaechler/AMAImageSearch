//
//  AFUnsplashAPIClient.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AFUnsplashAPIClient.h"

#import "ImageRecord.h"

static NSString * const kAFTumblrUnsplashAPIBaseURLString = @"https://api.tumblr.com/v2/blog/unsplash.tumblr.com/posts";

#warning Add your own client ID here
static NSString * const kAFTumblrAPIKey = @"";

@implementation AFUnsplashAPIClient

+ (NSString *)title
{
    return @"Unsplash";
}

+ (AFUnsplashAPIClient *)sharedClient
{
    static AFUnsplashAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFUnsplashAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFTumblrUnsplashAPIBaseURLString]];
    });

    return _sharedClient;
}

- (void)findImagesForQuery:(NSString *)query success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSDictionary *parameterDict = @{ @"api_key": kAFTumblrAPIKey };

    NSString *path = [NSString stringWithFormat:@"photo"];
    [[AFUnsplashAPIClient sharedClient] GET:path parameters:parameterDict
        success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSArray *jsonObjects = [responseObject valueForKeyPath:@"response.posts"];
            NSLog(@"Found %d objects...", [jsonObjects count]);
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageRecord *imageRecord = [[ImageRecord alloc] init];
                
                imageRecord.title = [jsonDict valueForKeyPath:@"caption"];
                if ((NSNull *)imageRecord.title == [NSNull null]) {
                    imageRecord.title = @"";
                }
                
                imageRecord.details = [jsonDict valueForKey:@"slug"];
                if ((NSNull *)imageRecord.details == [NSNull null]) {
                    imageRecord.details = @"";
                }
                
                NSArray *altSizes = [(NSArray *)[jsonDict valueForKeyPath:@"photos.alt_sizes"] firstObject];
                if (altSizes == nil || [altSizes count] < 1) {
                    continue;
                }
                imageRecord.thumbnailURL = [NSURL URLWithString:[altSizes.lastObject valueForKeyPath:@"url"]];
                
                NSArray *originalURL = [jsonDict valueForKeyPath:@"photos.original_size.url"];
                if (originalURL == nil || [originalURL count] < 1) {
                    continue;
                }
                imageRecord.imageURL = [NSURL URLWithString:originalURL[0]];
                
                [imageArray addObject:imageRecord];
            }
            
            success(operation, imageArray);
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            failure(operation, error);
        }];
}

@end
