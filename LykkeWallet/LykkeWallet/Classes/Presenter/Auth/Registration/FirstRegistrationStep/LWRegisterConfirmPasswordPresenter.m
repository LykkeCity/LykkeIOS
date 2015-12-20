//
//  LWRegisterConfirmPasswordPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterConfirmPasswordPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"
#import "TKPresenter+Loading.h"


@interface LWRegisterConfirmPasswordPresenter () <LWAuthManagerDelegate> {
    
}

@end


@implementation LWRegisterConfirmPasswordPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)goNext {
    [self setLoading:YES];

    LWRegistrationData *data = [LWRegistrationData new];
    //data.email = emailField.text;
    //data.firstName = firstNameField.text;
    //data.lastName = lastNameField.text;
    //data.phone = phoneField.text;
    //data.password = passwordField.text;
        
    [[LWAuthManager instance] requestRegistration:data];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.passwordConfirm");
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterConfirmPassword;
}


#pragma mark - LWRegisterBasePresenter

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validateConfirmPassword:input];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidRegister:(LWAuthManager *)manager {
    [[LWAuthManager instance] requestDocumentsToUpload];
}

- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status {
    [self setLoading:NO];
    
    if (status.documentTypeRequired != nil) {
        // navigate to selfie camera presenter
        [((LWAuthNavigationController *)self.navigationController)
         navigateToStep:LWAuthStepRegisterSelfie
         preparationBlock:nil];
    }
    else {
        // navigate to verification
        // ...
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
}

@end
