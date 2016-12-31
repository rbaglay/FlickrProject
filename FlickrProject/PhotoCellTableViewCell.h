//
//  PhotoCellTableViewCell.h
//  FlickrProject
//
//  Created by Roman Baglay on 24.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) NSURL *url;


-(void)addImageToCell:(NSURL *)url;


@end
