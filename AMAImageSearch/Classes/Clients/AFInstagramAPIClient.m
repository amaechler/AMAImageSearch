//
//  AFInstagramAPIClient.m
//  AMAImageSearch
//
//  Created by Andreas Maechler on 26.09.12.
//  Copyright (c) 2012 amaechler. All rights reserved.
//

#import "AFInstagramAPIClient.h"

#import "ImageRecord.h"

// https://api.instagram.com/v1/tags/QUERY/media/recent?client_id=<CLIENT_ID>
static NSString * const kAFInstagramAPIBaseURLString = @"https://api.instagram.com/v1";

#warning Add your own client ID here first
static NSString * const kAFInstagramAPIClientID = @"";


@interface AFInstagramAPIClient ()

@property (strong, nonatomic) NSString *max_id;

@end


@implementation AFInstagramAPIClient

+ (NSString *)title
{
    return @"Instagram";
}

+ (AFInstagramAPIClient *)sharedClient
{
    static AFInstagramAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFInstagramAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFInstagramAPIBaseURLString]];
    });

    return _sharedClient;
}

- (void)findImagesForQuery:(NSString *)query withOffset:(int)offset success:(ISSuccessBlock)success failure:(ISFailureBlock)failure
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionaryWithDictionary:@{ @"client_id": kAFInstagramAPIClientID }];
    if (self.max_id != nil) {
        parameterDict[@"max_id"] = self.max_id;
    }

    // Only allow alpha-numeric characters
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    query = [[query componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];

    NSString *path = [NSString stringWithFormat:@"tags/%@/media/recent", query];
    [[AFInstagramAPIClient sharedClient] GET:path parameters:parameterDict
        success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSArray *jsonObjects = [responseObject objectForKey:@"data"];
            NSLog(@"Found %lu objects...", (unsigned long)[jsonObjects count]);
            
            self.max_id = [responseObject valueForKeyPath:@"pagination.next_max_tag_id"];
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:jsonObjects.count];
            for (NSDictionary *jsonDict in jsonObjects) {
                ImageRecord *imageRecord = [[ImageRecord alloc] init];
                
                imageRecord.title = [jsonDict valueForKeyPath:@"caption.text"];
                if ((NSNull *)imageRecord.title == [NSNull null]) {
                    // If the caption does not exist, use the tags for titles
                    imageRecord.title = [[jsonDict valueForKeyPath:@"tags.description"] componentsJoinedByString:@", "];
                    if ((NSNull *)imageRecord.title == [NSNull null]) {
                        imageRecord.title = @"";
                    }
                }
                
                imageRecord.details = [jsonDict valueForKey:@"link"];
                if ((NSNull *)imageRecord.details == [NSNull null]) {
                    imageRecord.details = @"";
                }
                
                imageRecord.thumbnailURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"images.thumbnail.url"]];
                imageRecord.thumbnailSize = CGSizeMake([[jsonDict valueForKeyPath:@"images.thumbnail.width"] floatValue],
                                                       [[jsonDict valueForKeyPath:@"images.thumbnail.height"] floatValue]);

                imageRecord.imageURL = [NSURL URLWithString:[jsonDict valueForKeyPath:@"images.standard_resolution.url"]];
                
                [imageArray addObject:imageRecord];
            }
            
            success(operation, imageArray);
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            failure(operation, error);
        }];
}

@end
