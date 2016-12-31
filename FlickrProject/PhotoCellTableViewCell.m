//
//  PhotoCellTableViewCell.m
//  FlickrProject
//
//  Created by Roman Baglay on 24.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "PhotoCellTableViewCell.h"
#import "SearchViewController.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoCellTableViewCell

- (void) addImageToCell:(NSURL *)url {
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self.cellImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"logo"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.cellImageView.alpha = 0.0;
        self.cellImageView.image = image;
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.cellImageView.alpha = 1.0;
                         }];
    } failure:NULL];
    self.url = url;
    
}


@end
