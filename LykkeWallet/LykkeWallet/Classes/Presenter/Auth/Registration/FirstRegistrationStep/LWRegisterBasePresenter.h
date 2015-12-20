//
//  LWRegisterBasePresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthStepPresenter.h"


@class LWTextField;

@interface LWRegisterBasePresenter : LWAuthStepPresenter {
    
}

@property (copy, nonatomic) LWRegistrationData *registrationInfo;

- (void)goNext;
- (LWAuthStep)nextStep;
- (void)prepareNextStepData:(NSString *)input;
- (NSString *)fieldPlaceholder;
- (void)validateProceedButtonState;
- (BOOL)validateInput:(NSString *)input;
- (void)configureTextField:(LWTextField *)textField;

@end
