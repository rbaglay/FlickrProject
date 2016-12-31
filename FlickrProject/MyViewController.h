//
//  MyViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 06.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *backgraundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

- (void) addImageToView:(UIImage *)image;
@end
