//
//  AppDelegate.h
//  FlickrProject
//
//  Created by Roman Baglay on 11.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UINavigationController *navigationController;

@property (strong, nonatomic) FKViewController *viewController;




@end

