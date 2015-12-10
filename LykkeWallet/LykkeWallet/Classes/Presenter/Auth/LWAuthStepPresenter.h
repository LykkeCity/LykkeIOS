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
    LWAuthStepLoginPIN,
    LWAuthStepLoginPINSuccess,
    LWAuthStepRegisterProfile,
    LWAuthStepRegisterSelfie,
    LWAuthStepRegisterIdentity,
    LWAuthStepRegisterUtilityBill,
    LWAuthStepRegisterAwaitingVerification,
    LWAuthStepRegisterSuccess
};


@interface LWAuthStepPresenter : TKPresenter {
    
}

@property (readonly, nonatomic) LWAuthStep stepId;

@end
