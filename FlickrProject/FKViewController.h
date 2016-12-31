//
//  FKViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 17.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) NSString *userID;


- (IBAction)authButtonPressed:(id)sender;







@end
