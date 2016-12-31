//
//  ChooseViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 12.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseViewController : UIViewController
- (IBAction)addPhotoPressed:(id)sender;
- (IBAction)addPhotofromLibraryPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *addPhotofromLibraryOutlet;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoOutlet;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@end
