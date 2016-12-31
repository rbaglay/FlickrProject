//
//  FKAuthViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 17.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "FKAuthViewController.h"
#import "FlickrKit.h"

@interface FKAuthViewController ()
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@end

@implementation FKAuthViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *callbackURLString = @"FlickrProject://auth";
    
    // Begin the authentication process
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:callbackURLString] permission:FKPermissionDelete completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                [self.webView loadRequest:urlRequest];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:actionOK];
            }
        });
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.authOp cancel];
    [super viewWillDisappear:animated];
    
}

#pragma mark - Web View


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //If they click NO DONT AUTHORIZE, this is where it takes you by default... maybe take them to my own web site, or show something else
    
    NSURL *url = [request URL];
    
    // If it's the callback url, then lets trigger that
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
//            [[UIApplication sharedApplication]openURL:url];
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            return NO;
        }
    }
    
    return YES;
    
}

@end
