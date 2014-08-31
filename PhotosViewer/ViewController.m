//
//  ViewController.m
//  PhotosViewer
//
//  Created by n.shubenkov on 29/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import "ViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

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
    
    //add any tags you want
    PSRFlickrSearchOptions *options = [[PSRFlickrSearchOptions alloc]initWithTags:@[@"Kremlin]",@"arbat",@"gorky park"]];
    
    options.itemsLimit = 55;
    options.page = 22;
    options.coordinate = CLLocationCoordinate2DMake(55.756151, 37.61727);
    options.radiousKilometers = 50;
    
    options.extra = @[@"original_format",
                      @"tags",
                      @"description",
                      @"geo",
                      @"date_upload",
                      @"owner_name"];

    //this operation may take several seconds
    NSArray *photos = [[[PSRFlickrAPI alloc]init] requestPhotosWithOptions:options];
    NSParameterAssert(photos.count > 0);
    [self showPhotosFromEnumerator:[photos objectEnumerator]];
//    [self showPhotosWithWebImageWithEnumerator:[photos objectEnumerator]
//                                   placeHolder:nil];
}



- (void)showPhotosWithWebImageWithEnumerator:(NSEnumerator *)enumarator placeHolder:(UIImage *)placeHolder
{
    PSRFlickrPhoto *parsedPhoto = [enumarator nextObject];
    if (!parsedPhoto){
        return;
    }
    NSURL *url = [parsedPhoto highQualityURL];
    
    [self.photo sd_setImageWithURL:url
                  placeholderImage:placeHolder
     //вот тут была ошибка.
     //данный фреймворк при загрузке изображения до тех пор, пока
     //оно не загрузится ставит заглушку
     //так как заглушку я не предоставлял то он удалял предыдущее изображение
     //заменяя его пустотой. По завершении закачки тут сразу вызывается загрузка следующего изображения
     //соответственно пользователь опять видит пустоту.
                           options:SDWebImageDelayPlaceholder
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             [self showPhotosWithWebImageWithEnumerator:enumarator placeHolder:image];
                         }
     ];
}

- (void)showPhotosFromEnumerator:(NSEnumerator *)enumarator
{
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", 0);
    dispatch_async(downloadQueue, ^{
        NSLog(@"queue operation");
        PSRFlickrPhoto *parsedPhoto = [enumarator nextObject];
        if (!parsedPhoto){
            return;
        }
        
        NSData *photoData = [NSData dataWithContentsOfURL:[parsedPhoto highQualityURL]];
        
        NSLog(@"image downloaded");
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            self.photo.image = [UIImage imageWithData:photoData];
            [self showPhotosFromEnumerator:enumarator];
        });
    });
    NSLog(@"after callong dispatch_asynq");
}

@end
