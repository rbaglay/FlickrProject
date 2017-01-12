//
//  MyViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 06.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "MyViewController.h"
#import <FlickrKit.h>
#import "FKViewController.h"
#import "FKFlickrPeopleGetInfo.h"
#import "UIImageView+AFNetworking.h"
#import "MyCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "DetailedMyViewController.h"
#import "HeaderCollectionReusableView.h"
#import "FooterCollectionReusableView.h"

#define column_count 3
#define CELL_IDENTIFIER @"cell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface MyViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myGetUserInfoOp;
@property (nonatomic, retain) NSArray *photoURLs;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *iconserver;
@property (nonatomic, retain) NSString *iconfarm;
@property (nonatomic, strong) NSArray *cellSizes;
@end

@implementation MyViewController

- (void) dealloc {
    [self.myPhotostreamOp cancel];
    [self.myGetUserInfoOp cancel];
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgraundImage.image = [UIImage imageNamed:@"dnepr"];
      [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerHeight = 20;
    layout.footerHeight = 0;
    layout.minimumColumnSpacing = 20;
    layout.minimumInteritemSpacing = 30;
    [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER];
    [self.collectionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:FOOTER_IDENTIFIER];
    
    self.collectionView.collectionViewLayout = layout;


  }
    

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([FlickrKit sharedFlickrKit].isAuthorized)
    {
        self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if (!error)
                {
                    self.userId = userId;
                    self.userName.text = fullName;
                    [self getInfoUser:userId];
                    
                    if (self.photoURLs == nil) {

                    self.myPhotostreamOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"user_id": userId, @"per_page": @"100"} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary *response, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (response)
                            {
                                NSMutableArray *photoURLs = [NSMutableArray array];
                                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
                                {
                                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photoDictionary];
                                    [photoURLs addObject:url];
                                }
                                self.photoURLs = photoURLs;
                                [self.collectionView reloadData];
                                [MBProgressHUD hideHUDForView:self.view animated:YES];

                                                        }
                            else
                            {
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                           {
                                                           }];
                                [alert addAction:actionOK];
                            }
                        });
                    }];
                    }
                }
            }
        );}
    ];}
}

// Метод запроса данных для запроса аватарки пользователя
-(void)getInfoUser:(NSString *)userId
{
        FKFlickrPeopleGetInfo *peopleGetInfo = [[FKFlickrPeopleGetInfo alloc]init];
    peopleGetInfo.user_id = userId;
    self.myGetUserInfoOp = [[FlickrKit sharedFlickrKit]call:peopleGetInfo completion:^(NSDictionary *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (response)
            {
                NSDictionary *person  = [response valueForKeyPath:@"person"];
                    NSString *iconserver = [person valueForKeyPath:@"iconserver"];
                    self.iconserver = iconserver;
                    NSString *iconfarm = [person valueForKeyPath:@"iconfarm"];
                    self.iconfarm = iconfarm;
                
                NSString *urlString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", self.iconfarm, self.iconserver, self.userId];
                NSURL *url = [NSURL URLWithString:urlString];
                
                [self.userPhoto setImageWithURL:url];
                
            }
        }
                       );
        

    }];
    
    }

#pragma mark - Accessors

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       [NSValue valueWithCGSize:CGSizeMake(400, 550)],
                       [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
                       [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
                       [NSValue valueWithCGSize:CGSizeMake(640, 427)]
                       ];
    }
    return _cellSizes;
}

#pragma mark - Action

- (IBAction)logoutClicked:(id)sender {
    [[FlickrKit sharedFlickrKit] logout];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"flickr"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    // open start screen
    [UIApplication sharedApplication].keyWindow.rootViewController = [self.storyboard instantiateInitialViewController];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger countItems = [self.photoURLs count];
    return countItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    NSURL *url = [self.photoURLs objectAtIndex:indexPath.item];
    
    [cell addImageToCell:url];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
       HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        NSString *title = [NSString stringWithFormat:@"У Вас %li фотографий", [self.photoURLs count]];
        headerView.title = title;
        reusableView = headerView;
    }
    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
       FooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        reusableView = footerView;
    }

    return reusableView;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
}

#pragma mark - Navigation Orientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([sender isKindOfClass:[MyCollectionViewCell class]])
    {
        MyCollectionViewCell *cell = sender;
        DetailedMyViewController *detailedControler = segue.destinationViewController;
        detailedControler.imageURL = cell.url;
    }
}

@end
