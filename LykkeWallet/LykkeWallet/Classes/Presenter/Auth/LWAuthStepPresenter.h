//
//  LWAuthStepPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"

typedef NS_ENUM(NSInteger, LWAuthStep) {
    LWAuthStepEntryPoint,
    LWAuthStepPINEnter,
    LWAuthStepRegisterProfile,
    LWAuthStepRegisterSelfie,
    LWAuthStepRegisterIdentity,
    LWAuthStepRegisterUtilityBill,
    LWAuthStepRegisterKYCPending,
    LWAuthStepRegisterKYCInvalidDocuments,
    LWAuthStepRegisterKYCRestricted,
    LWAuthStepRegisterKYCSuccess,
    LWAuthStepRegisterPINSetup
};


@interface LWAuthStepPresenter : TKPresenter {
    
}

@property (readonly, nonatomic) LWAuthStep stepId;

@end
