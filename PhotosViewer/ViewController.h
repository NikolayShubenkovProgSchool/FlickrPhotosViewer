//
//  ViewController.h
//  PhotosViewer
//
//  Created by n.shubenkov on 29/08/14.
//  Copyright (c) 2014 n.shubenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

