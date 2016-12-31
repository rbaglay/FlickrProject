//
//  SearchViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 10.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "SearchViewController.h"
#import "FlickrKit.h"
#import "MBProgressHUD.h"
#import "PhotoCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailedPhotoViewController.h"


@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSArray *photoURLs;
@property (nonatomic, retain) FKFlickrNetworkOperation *mySearchOp;
@end

@implementation SearchViewController
- (void) dealloc {

}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBarHidden = YES;
    
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)searchModel{
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchText.text;
    search.per_page = @"500";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   self.mySearchOp = [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                NSMutableArray *photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photoDictionary];
                    [photoURLs addObject:url];
                    self.photoURLs = photoURLs;
                    [self.tableView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:actionOK];
            }
        });
    }];
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:indexPath
{
    
    return 270;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger countCell = [self.photoURLs count];
    
    return countCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    cell.tag = indexPath.row;
    NSURL *url = [self.photoURLs objectAtIndex:indexPath.row];
    
    if (cell.tag == indexPath.row) {
        [cell addImageToCell:url];

    }
        return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
//    [self.view endEditing:YES];
    [self searchModel];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.mySearchOp cancel];
    searchBar.text = nil;
}

#pragma mark - Navigation
//Данный метод вызовется пари любом переходе на новый экран при условии что этот  переход был настроен в сторибоарде
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Добавляем проверку что переход был вызван нажатием на ячейку  с новостью. Для этого проверим каким классом является объект sender
    if ([sender isKindOfClass:[PhotoCellTableViewCell class]])
    {
        PhotoCellTableViewCell *cell = sender;
        DetailedPhotoViewController *detailedControler = segue.destinationViewController;
        detailedControler.imageURL = cell.url;
    }
}


@end
