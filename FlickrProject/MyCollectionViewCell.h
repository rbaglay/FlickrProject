//
//  MyCollectionViewCell.h
//  FlickrProject
//
//  Created by Roman Baglay on 04.01.17.
//  Copyright © 2017 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemCollectionView;
@property (strong, nonatomic) NSURL *url;

- (void) addImageToCell:(NSURL *)url;
@end
