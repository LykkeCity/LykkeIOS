//
//  LWRegisterCameraPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterCameraPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWConstants.h"
#import "LWCameraOverlayPresenter.h"

#import "UIViewController+Loading.h"
#import "UIImage+Resize.h"

#import <AFNetworking/AFNetworking.h>


@interface LWRegisterCameraPresenter ()<LWAuthManagerDelegate, LWCameraOverlayDelegate> {
    LWCameraOverlayPresenter *cameraOverlayPresenter;
}

@property (nonatomic) UIImagePickerController *imagePickerController;


#pragma mark - Utils

- (void)checkButtonsState;
- (void)showCameraView;
- (void)setupImage:(UIImage *)image shouldCropImage:(BOOL)shouldCropImage;

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
    
#warning TODO: as request by customer (temporarly)
    self.navigationItem.hidesBackButton = YES;
    
    // hide back button if necessary
    if (self.shouldHideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    }

    if (self.showCameraImmediately) {
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
    [self clearImage];
    [self okButtonClick:nil];
}

- (IBAction)okButtonClick:(id)sender {
    if (photo) {
        [self setLoading:YES];

        // send photo
        KYCDocumentType type = [LWAuthSteps getDocumentTypeByStep:self.stepId];
        [[LWAuthManager instance] requestSendDocument:type image:photo];
        //[[LWAuthManager instance] requestSendDocumentBin:type image:photo];
    }
    else {
        [self showCameraView];
    }
}


#pragma mark - Utils

- (void)clearImage {
    photo = nil;
    self.photoImageView.image = nil;
}

- (void)checkButtonsState {
    if (photo) {
        [self.okButton setTitle:[Localize(@"register.camera.photo.ok") uppercaseString]
                       forState:UIControlStateNormal];
    }
    else {
        [self.okButton setTitle:[Localize(@"register.camera.photo.take") uppercaseString]
                       forState:UIControlStateNormal];
    }
}

- (void)showCameraView {
    
    // configure overlay
    if (!cameraOverlayPresenter) {
        cameraOverlayPresenter = [LWCameraOverlayPresenter new];
    }
    
    UIImagePickerController *picker = [UIImagePickerController new];
    // if camera is unavailable - set photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // configure image picker
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.showsCameraControls = NO;
        picker.cameraDevice = ((self.stepId == LWAuthStepRegisterSelfie)
                                    ? UIImagePickerControllerCameraDeviceFront
                                    : UIImagePickerControllerCameraDeviceRear);
        picker.toolbarHidden = YES;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;

        cameraOverlayPresenter.pickerReference = picker;
        cameraOverlayPresenter.view.frame = picker.cameraOverlayView.frame;
        cameraOverlayPresenter.step = self.stepId;
        cameraOverlayPresenter.delegate = self;

        picker.cameraOverlayView = cameraOverlayPresenter.view;
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    picker.delegate = self;

    self.imagePickerController = picker;
    [self presentViewController:self.imagePickerController animated:NO completion:^{
        [cameraOverlayPresenter updateView];
    }];
    
    [self checkButtonsState];
}

- (void)setupImage:(UIImage *)image shouldCropImage:(BOOL)shouldCropImage {
    photo = image;
    photo = [photo correctImageOrientation];
    
    // resize to our view
    CGFloat coeff = self.view.frame.size.width / photo.size.width;
    CGSize size = CGSizeMake(photo.size.width * coeff, photo.size.height * coeff);
    photo = [photo resizedImage:size interpolationQuality:kCGInterpolationDefault];

    // crop image for selfie
    if (shouldCropImage) {
        CGRect cropRect = self.photoImageView.frame;
        // hidden navigation bar
        CGFloat const navHeight = 56;
        cropRect.origin.y += navHeight;
        photo = [photo croppedImage:cropRect];
    }
    
    self.photoImageView.image = photo;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [[LWAuthManager instance] requestSendLog:@"Cancel choosen image"];
    [self checkButtonsState];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        [self setupImage:image shouldCropImage:YES];
    }];
    
    [[LWAuthManager instance] requestSendLog:@"Camera image selected"];
    [self checkButtonsState];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
}

- (void)authManagerDidSendDocument:(LWAuthManager *)manager ofType:(KYCDocumentType)docType {
    [self setLoading:NO];
    
    LWAuthNavigationController *navController = (LWAuthNavigationController *)self.navigationController;
    [navController navigateWithDocumentStatus:[LWAuthManager instance].documentsStatus hideBackButton:NO];
}


#pragma mark - LWCameraOverlayDelegate

- (void)fileChoosen:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (self.imagePickerController) {
        [self.imagePickerController dismissViewControllerAnimated:NO completion:^{
            [self setupImage:image shouldCropImage:NO];
        }];
    }
    
    [[LWAuthManager instance] requestSendLog:@"Camera file choosen"];
    [self checkButtonsState];
}

- (void)pictureTaken {
    self.showCameraImmediately = NO;
}


#pragma mark - Properties

- (void)setCurrentStep:(LWAuthStep)currentStep {
    _currentStep = currentStep;
    self.promptLabel.text = Localize([LWAuthSteps titleByStep:currentStep]);
}

@end
