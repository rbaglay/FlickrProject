//
//  FKViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 17.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "FKViewController.h"
#import "FlickrKit.h"
#import "FKAuthViewController.h"
#import "FKPhotosViewController.h"
#import "FKTabBarController.h"
#import "MyViewController.h"


@interface FKViewController ()
{
    NSString *userId;
}

@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;

@end

@implementation FKViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    // You should do this once on app launch
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
    
                
                UIViewController *mainTabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabbar"];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = mainTabbar;
            }
        });
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    //Cancel any operations when you leave views
    self.navigationController.navigationBarHidden = NO;
    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [super viewWillDisappear:animated];
}
#pragma mark - Auth

- (void) userAuthenticateCallback:(NSNotification *)notification {
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
                
                UIViewController *mainTabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTabbar"];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainTabbar;
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                             UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                }];
                [alert addAction:actionOK];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }];
}

- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID {
    self.userID = userID;
    [self.authButton setTitle:@"Выйти" forState:UIControlStateNormal];
    self.authLabel.text = [NSString stringWithFormat:@"Вы вошли как  %@", username];
}

- (void) userLoggedOut {
        [self.authButton setTitle:@"Войти" forState:UIControlStateNormal];
    self.authLabel.text = @"Авторизуйтесь в Flicker";
}

#pragma mark - Button Actions

    
- (IBAction) authButtonPressed:(id)sender {
    
        [self performSegueWithIdentifier:@"toAuthController" sender:nil];
    }

//-(NSString *)returnUserId{
//    
//    userId = _userID;
//    
//    return userId;
//}

@end
