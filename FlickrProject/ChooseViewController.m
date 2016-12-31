//
//  ChooseViewController.m
//  FlickrProject
//
//  Created by Roman Baglay on 12.12.16.
//  Copyright © 2016 Roman Baglay. All rights reserved.
//

#import "ChooseViewController.h"
#import "FlickrKit.h"

@interface ChooseViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addPhotoOutlet setImage:[UIImage imageNamed:@"camera-7"] forState:UIControlStateNormal];
    [self.addPhotofromLibraryOutlet setImage:[UIImage imageNamed:@"photo-7"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    }

- (void) viewWillDisappear:(BOOL)animated {
    //Cancel any operations when you leave views
//    [self.uploadOp cancel];
    [super viewWillDisappear:animated];
}


#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSURL* imageurl = [info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSDictionary *uploadArgs = @{@"title": @"Test Photo", @"description": @"A Test Photo via FlickrKitProject", @"is_public": @"0", @"is_friend": @"0", @"is_family": @"0", @"hidden": @"2"};
    
    self.progress.progress = 0.0;
    self.uploadOp =  [[FlickrKit sharedFlickrKit] uploadImage:image args:uploadArgs completion:^(NSString *imageID, NSError *error)  {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:actionOK];
            } else {
                NSString *msg = [NSString stringWithFormat:@"Uploaded image ID %@", imageID];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"DONE" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:actionOK];
            }
            [self.uploadOp removeObserver:self forKeyPath:@"uploadProgress" context:NULL];
        });
    }];
    [self.uploadOp addObserver:self forKeyPath:@"uploadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Progress KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        self.progress.progress = progress;
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    });
}

#pragma mark - Action

- (IBAction)addPhotoPressed:(id)sender {
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please login first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:actionOK];    }
    

    }

- (IBAction)addPhotofromLibraryPressed:(id)sender {
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please login first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:actionOK];    }
    
}
@end
