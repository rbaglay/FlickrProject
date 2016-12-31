//
//  AppDelegate.m
//  FlickrProject
//
//  Created by Roman Baglay on 11.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "AppDelegate.h"
#import "FKViewController.h"
#import "FlickrKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSString *scheme = [url scheme];
    if([@"flickrproject" isEqualToString:scheme]) {
        // I don't recommend doing it like this, it's just a demo... I use an authentication
        // controller singleton object in my projects
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];}
    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *scheme = [url scheme];
    if([@"flickrproject" isEqualToString:scheme]) {
        // I don't recommend doing it like this, it's just a demo... I use an authentication
        // controller singleton object in my projects
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialise FlickrKit with your flickr api key and shared secret
    NSString *apiKey = @"f87bc7ec6de3e46dcc21ad01091d9f40";
    NSString *secret = @"8b972171729089fa";
    if (!apiKey) {
        NSLog(@"\n----------------------------------\nYou need to enter your own 'apiKey' and 'secret' in FKAppDelegate for the demo to run. \n\nYou can get these from your Flickr account settings.\n----------------------------------\n");
        exit(0);
    }
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:apiKey sharedSecret:secret];
    return YES;
}



@end
