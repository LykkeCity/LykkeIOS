//
//  LWRegisterPasswordPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterPasswordPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterPasswordPresenter () {
    
}

@end


@implementation LWRegisterPasswordPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)goNext {
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:LWAuthStepRegisterConfirmPassword
     preparationBlock:nil];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.password");
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterPassword;
}


#pragma mark - LWRegisterBasePresenter

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validatePassword:input];
}

@end
