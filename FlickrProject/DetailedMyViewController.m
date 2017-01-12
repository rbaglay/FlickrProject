//
//  DetailedMyViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 05.01.17.
//  Copyright © 2017 Roman Baglay. All rights reserved.
//

#import "DetailedMyViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailedMyViewController () <UIGestureRecognizerDelegate>


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

    
}

#pragma mark - Action

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *) sender scale];
    
    
    
    if (factor > 1) { // увеличиваем размеры квадрата
        
       self.detailedImage.transform = CGAffineTransformMakeScale(lastScaleFactor + (factor - 1),
                                                     lastScaleFactor + (factor - 1));
    } else { // уменьшаем размеры
        self.detailedImage.transform = CGAffineTransformMakeScale(lastScaleFactor * factor,
                                                     lastScaleFactor * factor);
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (factor > 1){
            lastScaleFactor += (factor - 1);
        } else {
            lastScaleFactor *= factor;
        }
    }

}
@end
