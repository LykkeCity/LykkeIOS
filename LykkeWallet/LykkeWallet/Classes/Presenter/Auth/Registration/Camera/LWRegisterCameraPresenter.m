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

@interface LWRegisterCameraPresenter ()<LWAuthManagerDelegate, LWCameraOverlayDelegate> {
    LWCameraOverlayPresenter *cameraOverlayPresenter;
}

@property (nonatomic) UIImagePickerController *imagePickerController;


#pragma mark - Utils

- (void)checkButtonsState;
- (void)showCameraView;
- (void)setupImageFromInfo:(NSDictionary *)info;

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

- (void)setupImageFromInfo:(NSDictionary *)info {
    
    photo = [info objectForKey:UIImagePickerControllerOriginalImage];

    CGFloat const width = 1024.0;
    CGSize size = photo.size;
    CGFloat coeff = width / photo.size.width;
    size.width = width;
    size.height = size.height * coeff;
    
    photo = [photo resizedImage:size interpolationQuality:kCGInterpolationDefault];
    self.photoImageView.image = photo;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [[LWAuthManager instance] requestSendLog:@"Cancel choosen image"];
    [self checkButtonsState];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self setupImageFromInfo:info];

    [picker dismissViewControllerAnimated:NO completion:nil];
    
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
    
    if ([LWAuthManager instance].documentsStatus.documentTypeRequired) {
        // navigate to valid step with document uploading
        LWAuthStep step = [LWAuthSteps getNextDocumentByStatus:
                           [LWAuthManager instance].documentsStatus];
        
        [navController navigateToStep:step preparationBlock:^(LWAuthStepPresenter *presenter) {
            LWRegisterCameraPresenter *camera = (LWRegisterCameraPresenter *)presenter;
            camera.shouldHideBackButton = NO;
            camera.showCameraImmediately = YES;
            camera.currentStep = step;
        }];
    }
    else {
        // navigate to KYC submit
        [navController navigateToStep:LWAuthStepRegisterKYCSubmit preparationBlock:nil];
    }
}


#pragma mark - LWCameraOverlayDelegate

- (void)fileChoosen:(NSDictionary<NSString *,id> *)info {
    [self setupImageFromInfo:info];
    
    if (self.imagePickerController) {
        [self.imagePickerController dismissViewControllerAnimated:NO completion:nil];
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
