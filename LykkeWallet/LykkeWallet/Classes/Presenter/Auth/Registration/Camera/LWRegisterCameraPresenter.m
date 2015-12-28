//
//  LWRegisterCameraPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterCameraPresenter.h"
#import "LWAuthNavigationController.h"
#import "UIViewController+Loading.h"
#import "LWConstants.h"
#import "LWCameraOverlayPresenter.h"


@interface LWRegisterCameraPresenter ()<LWAuthManagerDelegate, LWCameraOverlayDelegate> {
    UIImagePickerController  *imagePicker;
    LWCameraOverlayPresenter *cameraOverlayPresenter;
}


#pragma mark - Utils

- (void)checkButtonsState;
- (void)showCameraView;

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
    
    UIColor *cancelColor = [UIColor colorWithHexString:kMainDarkElementsColor];
    [self.cancelButton setTitleColor:cancelColor forState:UIControlStateNormal];
    
    // hide back button if necessary
    if (self.shouldHideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    }
    
    if ([self isMovingToParentViewController]) {
        [self showCameraView];
    }
}

- (LWAuthStep)stepId {
    return self.currentStep;
}

- (void)localize {
    [self.cancelButton setTitle:[Localize(@"register.camera.photo.cancel") uppercaseString] forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)cancelButtonClick:(id)sender {
    photo = nil;
    self.photoImageView.image = nil;
    
    [self okButtonClick:nil];
}

- (IBAction)okButtonClick:(id)sender {
    if (photo) {
        [self setLoading:YES];

        // send photo
        KYCDocumentType type = [LWAuthSteps getDocumentTypeByStep:self.stepId];
        [[LWAuthManager instance] requestSendDocument:type image:photo];
    }
    else {
        [self showCameraView];
    }
}


#pragma mark - Utils

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

- (void)showCameraView {
    // create image picker
    if (!imagePicker) {
        imagePicker = [UIImagePickerController new];
    }
    
    // configure overlay
    if (!cameraOverlayPresenter) {
        cameraOverlayPresenter = [LWCameraOverlayPresenter new];
    }
    
    // if camera is unavailable - set photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // configure image picker
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePicker.showsCameraControls = NO;
        imagePicker.cameraDevice = ((self.stepId == LWAuthStepRegisterSelfie)
                                    ? UIImagePickerControllerCameraDeviceFront
                                    : UIImagePickerControllerCameraDeviceRear);
        imagePicker.toolbarHidden = YES;
        imagePicker.allowsEditing = NO;

        cameraOverlayPresenter.pickerReference = imagePicker;
        cameraOverlayPresenter.view.frame = imagePicker.cameraOverlayView.frame;
        cameraOverlayPresenter.step = self.stepId;
        cameraOverlayPresenter.delegate = self;

        imagePicker.cameraOverlayView = cameraOverlayPresenter.view;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:NO completion:^{
        [cameraOverlayPresenter updateView];
    }];
    
    [self checkButtonsState];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [self checkButtonsState];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoImageView.image = photo;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [self checkButtonsState];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
}

- (void)authManagerDidSendDocument:(LWAuthManager *)manager ofType:(KYCDocumentType)docType {
    [self setLoading:NO];
    
    LWAuthNavigationController *navController = (LWAuthNavigationController *)self.navigationController;
    
    if ([LWAuthManager instance].documentsStatus.documentTypeRequired) {
        // navigate to valid step with document uploading
        LWAuthStep step = [LWAuthSteps getNextDocumentByStatus:
                           [LWAuthManager instance].documentsStatus];
        
        [navController navigateToStep:step preparationBlock:^(LWAuthStepPresenter *presenter) {
            LWRegisterCameraPresenter *camera = (LWRegisterCameraPresenter *)presenter;
            camera.shouldHideBackButton = NO;
            camera.currentStep = step;
        }];
    }
    else {
        // navigate to KYC submit
        [navController navigateToStep:LWAuthStepRegisterKYCSubmit
                     preparationBlock:nil];
    }
}


#pragma mark - LWCameraOverlayDelegate

- (void)fileChoosen:(NSDictionary<NSString *,id> *)info {
    [self imagePickerController:imagePicker didFinishPickingMediaWithInfo:info];
}


#pragma mark - Properties

- (void)setCurrentStep:(LWAuthStep)currentStep {
    _currentStep = currentStep;
    self.promptLabel.text = Localize([LWAuthSteps titleByStep:currentStep]);
}

@end
