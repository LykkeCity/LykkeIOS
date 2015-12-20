//
//  LWRegisterBasePresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthStepPresenter.h"


@interface LWRegisterBasePresenter : LWAuthStepPresenter {
    LWRegistrationData *registrationInfo;
}

- (void)goNext;
- (NSString *)fieldPlaceholder;
- (void)validateProceedButtonState;
- (BOOL)validateInput:(NSString *)input;

@end
