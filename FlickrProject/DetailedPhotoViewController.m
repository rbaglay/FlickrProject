//
//  DetailedPhotoViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 27.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "DetailedPhotoViewController.h"
#import "UIImageView+AFNetworking.h"



@interface DetailedPhotoViewController ()

@end

@implementation DetailedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.detailedImage.backgroundColor = [UIColor blackColor];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self.detailedImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"logo"] success:nil failure:nil];
}

@end
