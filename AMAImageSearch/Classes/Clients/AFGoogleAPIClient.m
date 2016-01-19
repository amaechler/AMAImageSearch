//
//  AFGoogleAPIClient.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AFGoogleAPIClient.h"

#import "ImageRecord.h"

// https://www.googleapis.com/customsearch/v1?q=laura&key=&cx=&searchtype=image
static NSString * const kAFGoogleAPIBaseURLString = @"https://www.googleapis.com";

#warning Add your own Google API key and Google Custom Search Engine ID here first
static NSString * const kAFGoogleAPIKeyString = @"";
static NSString * const kAFGoogleAPIEngineIDString = @"";


@implementation AFGoogleAPIClient

+ (NSString *)title
{
    return @"Google Images";
}

+ (AFGoogleAPIClient *)sharedClient
{
    static AFGoogleAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFGoogleAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFGoogleAPIBaseURLString]];
    });

    return _sharedClient;
}

- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSDictionary *parameterDict = @{
        @"key": kAFGoogleAPIKeyString,
        @"cx": kAFGoogleAPIEngineIDString,
        @"searchtype": @"image",
        @"fields" : @ "items",
        @"start": [@(offset + 1) stringValue],
        @"q": query
    };
    
    [[AFGoogleAPIClient sharedClient] GET:@"customsearch/v1" parameters:parameterDict
        success:^(NSURLSessionDataTask *dataTask, id responseObject) {
            if ([responseObject objectForKey:@"items"] == [NSNull null]) {
                return;
            }
            
            NSArray *jsonObjects = [responseObject objectForKey:@"items"];
            NSLog(@"Found %lu objects...", (unsigned long)[jsonObjects count]);
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageRecord *imageRecord = [[ImageRecord alloc] init];
                
                imageRecord.title = [jsonDict objectForKey:@"title"];
                imageRecord.details = [jsonDict objectForKey:@"displayLink"];

                imageRecord.thumbnailURL = [NSURL URLWithString:[(NSArray *)[jsonDict valueForKeyPath:@"pagemap.cse_thumbnail.src"] firstObject]];
                imageRecord.thumbnailSize = CGSizeMake([[(NSArray *)[jsonDict valueForKeyPath:@"pagemap.cse_thumbnail.width"] firstObject] floatValue],
                                                       [[(NSArray *)[jsonDict valueForKeyPath:@"pagemap.cse_thumbnail.height"] firstObject] floatValue]);

                imageRecord.imageURL = [NSURL URLWithString:[(NSArray *)[jsonDict valueForKeyPath:@"pagemap.cse_image.src"] firstObject]];
                [imageArray addObject:imageRecord];
            }
            
            success(dataTask, imageArray);
        } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
            failure(dataTask, error);
        }];
    
}

@end
