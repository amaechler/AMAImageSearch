//
//  AFGoogleAPIClient.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AFGoogleAPIClient.h"

//#import "AFJSONRequestOperation.h"
#import "ImageRecord.h"

// http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q=dog
static NSString * const kAFGoogleAPIBaseURLString = @"http://ajax.googleapis.com";


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
    NSDictionary *parameterDict = @{ @"v": @"1.0", @"rsz": @"8", @"start": [@(offset) stringValue], @"q": query };
    
    [[AFGoogleAPIClient sharedClient] GET:@"ajax/services/search/images" parameters:parameterDict
        success:^(NSURLSessionDataTask *dataTask, id responseObject) {
            if ([responseObject objectForKey:@"responseData"] == [NSNull null]) {
                return;
            }
            
            NSArray *jsonObjects = [[responseObject objectForKey:@"responseData"] objectForKey:@"results"];
            NSLog(@"Found %d objects...", [jsonObjects count]);
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageRecord *imageRecord = [[ImageRecord alloc] init];
                
                imageRecord.title = [jsonDict objectForKey:@"contentNoFormatting"];
                imageRecord.details = [jsonDict objectForKey:@"originalContextUrl"];
                
                imageRecord.thumbnailURL = [NSURL URLWithString:[jsonDict objectForKey:@"tbUrl"]];
                imageRecord.thumbnailSize = CGSizeMake([[jsonDict valueForKeyPath:@"tbWidth"] floatValue],
                                                       [[jsonDict valueForKeyPath:@"tbHeight"] floatValue]);

                imageRecord.imageURL = [NSURL URLWithString:[jsonDict objectForKey:@"url"]];
                imageRecord.imageSize = CGSizeMake([[jsonDict valueForKeyPath:@"width"] floatValue],
                                                       [[jsonDict valueForKeyPath:@"height"] floatValue]);
                
                [imageArray addObject:imageRecord];
            }
            
            success(dataTask, imageArray);
        } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
            failure(dataTask, error);
        }];
    
}

@end
