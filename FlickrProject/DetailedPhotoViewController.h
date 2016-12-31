//
//  DetailedPhotoViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 27.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *detailedImage;
@property (strong, nonatomic) NSURL *imageURL;

@end
