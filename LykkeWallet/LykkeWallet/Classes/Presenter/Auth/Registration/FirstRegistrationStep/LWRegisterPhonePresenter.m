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

- (void)goNext {
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:LWAuthStepRegisterPassword
     preparationBlock:nil];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.phone");
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterPhone;
}


#pragma mark - LWRegisterBasePresenter

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validatePhone:input];
}

@end
