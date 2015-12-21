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


#pragma mark - LWRegisterBasePresenter

- (void)proceedToNextStep {
    [self setLoading:YES];
    [[LWAuthManager instance] requestRegistration:self.registrationInfo];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.passwordConfirm");
}

- (BOOL)validateInput:(NSString *)input {
    return ([LWValidator validateConfirmPassword:input]
            && [self.registrationInfo.password isEqualToString:input]);
}

- (void)configureTextField:(LWTextField *)textField {
    textField.secure = YES;
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterConfirmPassword;
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
