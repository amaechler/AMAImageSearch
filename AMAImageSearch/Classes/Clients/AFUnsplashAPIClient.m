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

- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSDictionary *parameterDict = @{ @"api_key": kAFTumblrAPIKey, @"offset": [@(offset) stringValue] };

    [[AFUnsplashAPIClient sharedClient] GET:@"photo" parameters:parameterDict
        success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSArray *jsonObjects = [responseObject valueForKeyPath:@"response.posts"];
            NSLog(@"Found %lu objects...", (unsigned long)[jsonObjects count]);
            
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
                
                id thumbnailPhoto = ([altSizes count] > 1) ? altSizes[altSizes.count - 2] : [altSizes lastObject];
                imageRecord.thumbnailURL = [NSURL URLWithString:[thumbnailPhoto valueForKeyPath:@"url"]];
                imageRecord.thumbnailSize = CGSizeMake([[thumbnailPhoto valueForKeyPath:@"width"] floatValue],
                                                       [[thumbnailPhoto valueForKeyPath:@"height"] floatValue]);
                
                id originalPhoto = [[jsonDict valueForKeyPath:@"photos.original_size"] firstObject];
                if (originalPhoto == nil) {
                    continue;
                }

                imageRecord.imageURL = [NSURL URLWithString:[originalPhoto valueForKeyPath:@"url"]];

                [imageArray addObject:imageRecord];
            }
            
            success(operation, imageArray);
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            failure(operation, error);
        }];
}

@end
