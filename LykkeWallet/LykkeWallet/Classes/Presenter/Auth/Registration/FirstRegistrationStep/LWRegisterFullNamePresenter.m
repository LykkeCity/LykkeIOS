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


@interface LWRegisterFullNamePresenter ()  {
    
}

@end


@implementation LWRegisterFullNamePresenter


#pragma mark - LWRegisterBasePresenter

- (void)prepareNextStepData:(NSString *)input {
    self.registrationInfo.fullName = input;
}

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validateFullName:input];
}

- (void)configureTextField:(LWTextField *)textField {
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.fullName");
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)nextStep {
    return LWAuthStepRegisterPhone;
}

- (LWAuthStep)stepId {
    return LWAuthStepRegisterFullName;
}

@end
