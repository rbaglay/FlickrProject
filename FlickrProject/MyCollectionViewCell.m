//
//  MyCollectionViewCell.m
//  FlickrProject
//
//  Created by Roman Baglay on 04.01.17.
//  Copyright © 2017 Roman Baglay. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MyCollectionViewCell
- (void) addImageToCell:(NSURL *)url {
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self.itemCollectionView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:nil] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.itemCollectionView.alpha = 0.0;
        self.itemCollectionView.image = image;
        [UIView animateWithDuration:0.8
                         animations:^{
                             self.itemCollectionView.alpha = 1.0;
                         }];
    } failure:NULL];
    self.url = url;
    
}


@end
