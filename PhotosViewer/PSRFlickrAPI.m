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

- (id)requestPhotosWithOptions:(PSRFlickrSearchOptions *)options
{
    NSParameterAssert(options);
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",[self stringWithMethod:@"method=flickr.photos.search"],[options requestString]];
    
    NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
    
    NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    return responseString;
}

#pragma mark - Private

@end
