//
//  AMAHelperUtils.m
//  AMAImageSearch
//
//  Created by Andreas Mächler on 07.02.14.
//  Copyright (c) 2014 amaechler. All rights reserved.
//

#import "AMAHelperUtils.h"

@implementation AMAHelperUtils

// A function for parsing URL parameters
+ (NSDictionary *)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    
    return params;
}

@end
