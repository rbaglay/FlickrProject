//
//  MyViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 06.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "MyViewController.h"
#import <FlickrKit.h>
#import "FKViewController.h"
#import "FKFlickrPeopleGetInfo.h"
#import "UIImageView+AFNetworking.h"

@interface MyViewController ()
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myGetUserInfoOp;
@property (nonatomic, retain) NSArray *photoURLs;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *iconserver;
@property (nonatomic, retain) NSString *iconfarm;
@end

@implementation MyViewController

- (void) dealloc {
    [self.myPhotostreamOp cancel];
    [self.myGetUserInfoOp cancel];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgraundImage.image = [UIImage imageNamed:@"dnepr"];
      [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];

  }
    

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([FlickrKit sharedFlickrKit].isAuthorized)
    {
        self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if (!error)
                {
                    self.userId = userId;
                    self.userName.text = fullName;
                    [self getInfoUser:userId];
                    
                    self.myPhotostreamOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"user_id": userId, @"per_page": @"15"} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary *response, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (response)
                            {
                                NSMutableArray *photoURLs = [NSMutableArray array];
                                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
                                {
                                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                                    [photoURLs addObject:url];
                                }
                                self.photoURLs = photoURLs;
                                for (NSURL *url in self.photoURLs)
                                {
                                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                                    {
                                        UIImage *image = [[UIImage alloc] initWithData:data];
                                        [self addImageToView:image];
                                    }];
                                }
                            }
                            else
                            {
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                           {
                                                           }];
                                [alert addAction:actionOK];
                            }
                        });
                    }];
                }
            }
        );}
    ];}
}

// Метод запроса данных для запроса аватарки пользователя
-(void)getInfoUser:(NSString *)userId
{
        FKFlickrPeopleGetInfo *peopleGetInfo = [[FKFlickrPeopleGetInfo alloc]init];
    peopleGetInfo.user_id = userId;
    self.myGetUserInfoOp = [[FlickrKit sharedFlickrKit]call:peopleGetInfo completion:^(NSDictionary *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (response)
            {
                NSDictionary *person  = [response valueForKeyPath:@"person"];
                    NSString *iconserver = [person valueForKeyPath:@"iconserver"];
                    self.iconserver = iconserver;
                    NSString *iconfarm = [person valueForKeyPath:@"iconfarm"];
                    self.iconfarm = iconfarm;
                
                NSString *urlString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", self.iconfarm, self.iconserver, self.userId];
                
                
                NSURL *url = [NSURL URLWithString:urlString];
                
                [self.userPhoto setImageWithURL:url];
                
            }
        }
                       );
        

    }];
    
    }

- (void) addImageToView:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = CGRectGetWidth(self.imageScrollView.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = 0;
    CGFloat y = self.imageScrollView.contentSize.height;
    
    imageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat newHeight = self.imageScrollView.contentSize.height + height;
    self.imageScrollView.contentSize = CGSizeMake(320, newHeight);
    
    [self.imageScrollView addSubview:imageView];
}



#pragma mark - Action

- (IBAction)logoutClicked:(id)sender {
    [[FlickrKit sharedFlickrKit] logout];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"flickr"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    // open start screen
    [UIApplication sharedApplication].keyWindow.rootViewController = [self.storyboard instantiateInitialViewController];
    
}


@end
