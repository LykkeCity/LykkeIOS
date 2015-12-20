//
//  LWKYCInvalidDocumentsPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 15.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCInvalidDocumentsPresenter.h"
#import "LWRegistrationData.h"


@interface LWKYCInvalidDocumentsPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel  *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel  *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;


#pragma mark - Actions

- (IBAction)okButtonClick:(id)sender;

@end


@implementation LWKYCInvalidDocumentsPresenter


#pragma mark - LWAuthStepPresenter

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
    [((LWAuthNavigationController *)self.navigationController) navigateToStep:LWAuthStepEntryPoint
                                                             preparationBlock:nil];
}

@end
