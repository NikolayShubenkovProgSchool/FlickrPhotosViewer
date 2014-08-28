//
//  ViewController.m
//  PhotosViewer
//
//  Created by n.shubenkov on 29/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import "ViewController.h"

#import "PSRFlickrAPI.h"

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
    
    NSString *result = [[[PSRFlickrAPI alloc]initWithAPIKey:apiKey] requestPhotosWithOptions:options];
}

@end
