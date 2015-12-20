//
//  LWRegisterFNPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterFullNamePresenter.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterFullNamePresenter ()

@end


@implementation LWRegisterFullNamePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - LWRegisterBasePresenter

- (LWAuthStep)nextStep {
    return LWAuthStepRegisterPhone;
}

- (void)prepareNextStepData:(NSString *)input {
    self.registrationInfo.fullName = input;
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.fullName");
}

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validateFullName:input];
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterFullName;
}

@end
