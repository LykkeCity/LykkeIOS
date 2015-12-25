//
//  LWKYCInvalidDocumentsPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 15.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCInvalidDocumentsPresenter.h"
#import "LWRegisterCameraPresenter.h"
#import "LWRegistrationData.h"
#import "UIViewController+Loading.h"


@interface LWKYCInvalidDocumentsPresenter () {
    LWAuthStep nextStep;
}

@property (weak, nonatomic) IBOutlet UILabel  *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel  *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;


#pragma mark - Actions

- (IBAction)okButtonClick:(id)sender;

@end


@implementation LWKYCInvalidDocumentsPresenter


#pragma mark - LWAuthStepPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setLoading:YES];
    
    [[LWAuthManager instance] requestDocumentsToUpload];
}

- (void)localize {
    self.headerLabel.text = Localize(@"register.kyc.invalidDocuments.header");
    self.textLabel.text = [NSString stringWithFormat:Localize(@"register.kyc.invalidDocuments"),
                           [LWAuthManager instance].registrationData.fullName];
    [self.okButton setTitle:[Localize(@"register.kyc.invalidDocuments.okButton") uppercaseString]
                   forState:UIControlStateNormal];
}

- (LWAuthStep)stepId {
    return LWAuthStepRegisterKYCInvalidDocuments;
}


#pragma mark - Actions

- (IBAction)okButtonClick:(id)sender {
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:nextStep
     preparationBlock:^(LWAuthStepPresenter *presenter) {
         ((LWRegisterCameraPresenter *)presenter).shouldHideBackButton = YES;
     }];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status {
    [self setLoading:NO];
    
    nextStep = LWAuthStepRegisterKYCInvalidDocuments;
    
    if (!status.isSelfieUploaded) {
        // to selfie
        nextStep = LWAuthStepRegisterSelfie;
    }
    else if (!status.isIdCardUploaded) {
        // to identity card
        nextStep = LWAuthStepRegisterIdentity;
    }
    else if (!status.isPOAUploaded) {
        // to POA
        nextStep = LWAuthStepRegisterUtilityBill;
    }
    else {
        NSAssert(0, @"Invalid documents status, we can't have invalid documents if they are all uploaded.");
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    
    if (reject) {
        [self showReject:reject];
    }
    else {
        // some server error? Then just repeat request after some delay
        const NSInteger repeatSeconds = 5;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LWAuthManager instance] requestDocumentsToUpload];
        });
    }
}

@end
