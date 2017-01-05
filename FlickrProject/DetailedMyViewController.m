//
//  DetailedMyViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 05.01.17.
//  Copyright © 2017 Roman Baglay. All rights reserved.
//

#import "DetailedMyViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailedMyViewController ()

@end

@implementation DetailedMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.detailedImage.backgroundColor = [UIColor blackColor];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self.detailedImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"logo"] success:nil failure:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
