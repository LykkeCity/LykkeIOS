//
//  LWRegisterCameraPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterCameraPresenter.h"
#import "LWAuthManager.h"
#import "MBProgressHUD.h"


@interface LWRegisterCameraPresenter ()<LWAuthManagerDelegate> {
    
}

#pragma mark - Utils

- (void)startLoading;
- (void)checkButtonsState;

@end


@implementation LWRegisterCameraPresenter


#pragma mark - TKPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"register.title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkButtonsState];
    
    [LWAuthManager instance].delegate = self;
}

- (void)localize {
    NSString *tag = nil;
    switch (self.stepId) {
        case LWAuthStepRegisterSelfie: {
            tag = @"register.camera.title.selfie";
            break;
        }
        case LWAuthStepRegisterIdentity: {
            tag = @"register.camera.title.idCard";
            break;
        }
        case LWAuthStepRegisterUtilityBill: {
            tag = @"register.camera.title.proofOfAddress";
            break;
        }
        default: {
            break;
        }
    }
    NSAssert(tag, @"Invalid step.");
    
    self.promptLabel.text = Localize(tag);
    [self.cancelButton setTitle:[Localize(@"register.camera.photo.cancel") uppercaseString]
                       forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)cancelButtonClick:(id)sender {
    photo = nil;
    self.photoImageView.image = nil;
    
    [self okButtonClick:nil];
}

- (IBAction)okButtonClick:(id)sender {
    if (photo) {
        [self startLoading];
        // send photo
        KYCDocumentType type = ((self.stepId == LWAuthStepRegisterSelfie)
                                ? KYCDocumentTypeSelfie
                                : ((self.stepId == LWAuthStepRegisterIdentity)
                                   ? KYCDocumentTypeIdCard
                                   : KYCDocumentTypeProofOfAddress));
        [[LWAuthManager instance] requestSendDocument:type image:photo];
    }
    else {
        // display image picker
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.sourceType = (/*UIImagePickerControllerSourceTypeCamera
                                  | */UIImagePickerControllerSourceTypePhotoLibrary);
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        [self checkButtonsState];
    }
}


#pragma mark - Utils

- (void)startLoading {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)checkButtonsState {
    if (photo) {
        self.cancelButton.hidden = NO;
        [self.okButton setTitle:[Localize(@"register.camera.photo.ok") uppercaseString]
                       forState:UIControlStateNormal];
    }
    else {
        self.cancelButton.hidden = YES;
        [self.okButton setTitle:[Localize(@"register.camera.photo.take") uppercaseString]
                       forState:UIControlStateNormal];
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self checkButtonsState];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoImageView.image = photo;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self checkButtonsState];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFail:(NSDictionary *)reject {
    [[MBProgressHUD HUDForView:self.navigationController.view] hide:YES];
    
    NSString *message = [reject objectForKey:@"Message"];
    
    UIAlertController *ctrl = [UIAlertController
                               alertControllerWithTitle:Localize(@"utils.error")
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:Localize(@"utils.ok")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ctrl dismissViewControllerAnimated:YES
                                                                                  completion:nil];
                                                     }];
    [ctrl addAction:actionOK];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status {
    // maybe IdCard or POA is still required
    // ...
    NSLog(@"completed");
}

- (void)authManagerDidSendDocument:(LWAuthManager *)manager ofType:(KYCDocumentType)docType {
    [[LWAuthManager instance] requestDocumentsToUpload];
}

@end
