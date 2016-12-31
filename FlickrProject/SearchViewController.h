//
//  SearchViewController.h
//  FlickrProject
//
//  Created by Roman Baglay on 10.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
