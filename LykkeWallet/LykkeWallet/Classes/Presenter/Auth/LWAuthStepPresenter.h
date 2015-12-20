//
//  LWAuthStepPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"
#import "LWAuthManager.h"

typedef NS_ENUM(NSInteger, LWAuthStep) {
    LWAuthStepEntryPoint,

    LWAuthStepAuthentication,
    
    LWAuthStepRegisterFullName,
    LWAuthStepRegisterPhone,
    LWAuthStepRegisterPassword,
    LWAuthStepRegisterConfirmPassword,
    
    LWAuthStepRegisterSelfie,
    LWAuthStepRegisterIdentity,
    LWAuthStepRegisterUtilityBill,
    LWAuthStepRegisterKYCSubmit,
    LWAuthStepRegisterKYCPending,
    LWAuthStepRegisterKYCInvalidDocuments,
    LWAuthStepRegisterKYCRestricted,
    LWAuthStepRegisterKYCSuccess,
    LWAuthStepRegisterPINSetup
};


@interface LWAuthStepPresenter : TKPresenter<LWAuthManagerDelegate> {
    
}

@property (readonly, nonatomic) LWAuthStep stepId;

@end
