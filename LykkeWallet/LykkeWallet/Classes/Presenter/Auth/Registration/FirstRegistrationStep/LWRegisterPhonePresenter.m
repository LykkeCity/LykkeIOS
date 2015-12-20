//
//  LWRegisterPhonePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterPhonePresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterPhonePresenter ()

@end


@implementation LWRegisterPhonePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - LWRegisterBasePresenter

- (LWAuthStep)nextStep {
    return LWAuthStepRegisterPassword;
}

- (void)prepareNextStepData:(NSString *)input {
    self.registrationInfo.phone = input;
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.phone");
}

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validatePhone:input];
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterPhone;
}

@end
