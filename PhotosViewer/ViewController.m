//
//  ViewController.m
//  PhotosViewer
//
//  Created by n.shubenkov on 29/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import "ViewController.h"

#import "PSRFlickrAPI.h"
#import "PSRFlickrPhoto.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *apiKey = @"";
    
    PSRFlickrSearchOptions *options = [[PSRFlickrSearchOptions alloc]initWithTags:@[@"World"]];
    options.unitsLimit = 55;
    options.page = 22;
    options.extra = @[@"original_format",
                      @"tags",
                      @"description",
                      @"geo",
                      @"date_upload",
                      @"owner_name"];

    NSArray *photos = [[[PSRFlickrAPI alloc]initWithAPIKey:apiKey] requestPhotosWithOptions:options];
    NSParameterAssert(photos.count > 0);
    
    [self showPhotosFromEnumerator:[photos objectEnumerator]];
}

- (void)showPhotosFromEnumerator:(NSEnumerator *)enumarator
{
    PSRFlickrPhoto *parsedPhoto = [[PSRFlickrPhoto alloc]initWithInfo:[enumarator nextObject]];
    if (!parsedPhoto){
        return;
    }
    NSData *photoData = [NSData dataWithContentsOfURL:[parsedPhoto lowQualityUrl]];

    [NSThread sleepForTimeInterval:1];
        
    self.photo.image = [UIImage imageWithData:photoData];
    
#warning напиши иначе
    
    [self performSelector:@selector(showPhotosFromEnumerator:)
               withObject:enumarator
               afterDelay:0.01];
}

@end
