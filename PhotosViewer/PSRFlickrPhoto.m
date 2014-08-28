//
//  PSRFlickrPhoto.m
//  PhotosViewer
//
//  Created by n.shubenkov on 29/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import "PSRFlickrPhoto.h"

@interface PSRFlickrPhoto()
@property (nonatomic, strong) NSDictionary *info;
@end

@implementation PSRFlickrPhoto

- (instancetype)initWithInfo:(NSDictionary *)info
{
    if (self = [super init]){
        _info = info;
    }
    return self;
}

- (NSURL *)lowQualityUrl
{
    NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_b.jpg", [self.info objectForKey:@"farm"], [self.info objectForKey:@"server"], [self.info objectForKey:@"id"], [self.info objectForKey:@"secret"]];
    return [NSURL URLWithString:photoURLString];
}

@end
