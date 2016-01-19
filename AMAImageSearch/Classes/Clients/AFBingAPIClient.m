//
//  AFBingAPIClient.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AFBingAPIClient.h"

#import "ImageRecord.h"

// https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27image%27&Query=%27kevin%20durant%27
static NSString * const kAFBingAPIBaseURLString = @"https://api.datamarket.azure.com/Bing/Search/v1/";

#warning Add your own client ID here first
static NSString * const kAFBingAPIPrimaryAccountKey = @"";


@implementation AFBingAPIClient

+ (NSString *)title
{
    return @"Bing Images";
}

+ (AFBingAPIClient *)sharedClient
{
    static AFBingAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFBingAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFBingAPIBaseURLString]];
    });

    return _sharedClient;
}

- (AFBingAPIClient *)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // Set the authentication header
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@""
                                                               password:kAFBingAPIPrimaryAccountKey];
    }
    return self;
}


- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSDictionary *parameterDict = @{ @"Query": [NSString stringWithFormat:@"'%@'", query],
                                     @"$format": @"JSON",
                                     @"$skip": [@(offset) stringValue] };
    
    [[AFBingAPIClient sharedClient] GET:@"Image" parameters:parameterDict
        success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSArray *jsonObjects = [responseObject valueForKeyPath:@"d.results"];
            NSLog(@"Found %lu objects...", (unsigned long)[jsonObjects count]);
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageRecord *imageRecord = [[ImageRecord alloc] init];
                
                imageRecord.title = [jsonDict valueForKeyPath:@"Title"];
                if ((NSNull *)imageRecord.title == [NSNull null]) {
                    imageRecord.title = @"";
                }
                
                imageRecord.details = [jsonDict valueForKey:@"DisplayUrl"];
                if ((NSNull *)imageRecord.details == [NSNull null]) {
                    imageRecord.details = @"";
                }
                
                imageRecord.thumbnailURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"Thumbnail.MediaUrl"]];
                imageRecord.thumbnailSize = CGSizeMake([[jsonDict valueForKeyPath:@"Thumbnail.Width"] floatValue],
                                                       [[jsonDict valueForKeyPath:@"Thumbnail.Height"] floatValue]);
                imageRecord.imageURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"MediaUrl"]];
                
                [imageArray addObject:imageRecord];
            }
            
            success(operation, imageArray);
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            failure(operation, error);
        }];
}

@end
