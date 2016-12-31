//
//  FKFivePhotosViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 17.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKPhotosViewController : UIViewController

- (id) initWithURLArray:(NSArray *)urlArray;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@end
