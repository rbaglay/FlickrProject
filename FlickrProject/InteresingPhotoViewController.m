//
//  InteresingPhotoViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 12.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "InteresingPhotoViewController.h"
#import <FlickrKit.h>
#import "MBProgressHUD.h"

@interface InteresingPhotoViewController ()
@property (nonatomic, retain) NSArray *photoURLs;
@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@end


@implementation InteresingPhotoViewController
- (void) dealloc {
        [self.todaysInterestingOp cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated {
    //Cancel any operations when you leave views
    self.navigationController.navigationBarHidden = NO;
    [self.todaysInterestingOp cancel];
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

//Using the model objects

FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
interesting.per_page = @"100";
self.todaysInterestingOp = [[FlickrKit sharedFlickrKit] call:interesting completion:^(NSDictionary *response, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (response) {
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                [photoURLs addObject:url];
            }
            
            self.photoURLs = photoURLs;
            for (NSURL *url in self.photoURLs) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    [self addImageToView:image];
                    
                }];
            }

        } else {
            /*
             Iterating over specific errors for each service
             */
            switch (error.code) {
                case FKFlickrInterestingnessGetListError_ServiceCurrentlyUnavailable:
                    
                    break;
                default:
                    break;
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes, please"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No, thanks"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
        }
    });
}];
}
- (void) addImageToView:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = CGRectGetWidth(self.interesingPhotoScrollView.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = 0;
    CGFloat y = self.interesingPhotoScrollView.contentSize.height;
    
    imageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat newHeight = self.interesingPhotoScrollView.contentSize.height + height;
    self.interesingPhotoScrollView.contentSize = CGSizeMake(320, newHeight);
    
    [self.interesingPhotoScrollView addSubview:imageView];
}

@end
