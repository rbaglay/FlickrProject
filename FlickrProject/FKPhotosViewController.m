//
//  FKFivePhotosViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 17.11.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "FKPhotosViewController.h"

@interface FKPhotosViewController ()
@property (nonatomic, retain) NSArray *photoURLs;
@end

@implementation FKPhotosViewController

- (id) initWithURLArray:(NSArray *)urlArray {
    self = [super init];
    if (self) {
        self.photoURLs = urlArray;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (NSURL *url in self.photoURLs) {
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
			
			UIImage *image = [[UIImage alloc] initWithData:data];
			[self addImageToView:image];
			
		}];
	}
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

@end
