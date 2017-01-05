//
//  DetailedMyViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 05.01.17.
//  Copyright © 2017 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedMyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailedImage;
@property (strong, nonatomic) NSURL *imageURL;
@end
