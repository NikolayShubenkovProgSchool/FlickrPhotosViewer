//
//  FlickrFetcher.m
//  PhotosViewer
//
//  Created by n.shubenkov on 29/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import "PSRFlickrAPI.h"

@interface PSRFlickrAPI ()
@property (nonatomic, copy)NSString *key;
@end

@implementation PSRFlickrAPI

const NSString * PSRDefaultApiUrl = @"https://api.flickr.com/services/rest/?";

#pragma mark - Public -

- (instancetype)initWithAPIKey:(NSString *)apiKey
{
    if (self = [super init]){
        _key = [apiKey copy];
    }
    return self;
}

- (NSString *)keyRequestString
{
    return [NSString stringWithFormat:@"&api_key=%@",self.key];
}

- (NSString *)stringWithMethod:(NSString *)method
{
    return [NSString stringWithFormat:@"%@%@%@",PSRDefaultApiUrl,method,[self keyRequestString]];
}

- (NSDictionary *)serializeRequest:(NSString *)requestString
{
    NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
    
    NSLog(@"result bytes:%lu",response.length);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    return json;
}

- (NSDictionary *)fetchRequestMethodName:(NSString *)methodName options:(PSRFlickrSearchOptions *)options
{
    NSString *requestString = [NSString stringWithFormat:@"%@%@",[self stringWithMethod:[NSString stringWithFormat:@"method=%@",methodName]],[options requestString]];
    requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [self serializeRequest:requestString];
    return json;
}

- (id)requestPhotosWithOptions:(PSRFlickrSearchOptions *)options
{
    NSParameterAssert(options);
    
    NSDictionary *json = [self fetchRequestMethodName:@"flickr.photos.search"
                                              options:options];
    NSLog(@"received: %@",json);
    
    return json[@"photos"][@"photo"];
}

#pragma mark - Private

@end
