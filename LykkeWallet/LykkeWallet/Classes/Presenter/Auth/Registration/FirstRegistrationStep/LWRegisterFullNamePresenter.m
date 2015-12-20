//
//  LWRegisterFNPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterFullNamePresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterFullNamePresenter ()

@end


@implementation LWRegisterFullNamePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)goNext {
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:LWAuthStepRegisterPhone
     preparationBlock:nil];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.fullName");
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterFullName;
}


#pragma mark - LWRegisterBasePresenter

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validateFullName:input];
}

@end
