//
//  LWAuthStepPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"

typedef NS_ENUM(NSInteger, LWAuthStep) {
    LWAuthStepNone,
    // existing account
    LWAuthStepPIN,
    LWAuthStepPINSuccess,
    // new account
    LWAuthStepProfile,
    LWAuthStepSelfie,
    LWAuthStepIdentity,
    LWAuthStepUtilityBill,
    LWAuthStepAwaitingVerification,
    LWAuthStepSuccess
};


@interface LWAuthStepPresenter : TKPresenter {
    
}

@property (assign, nonatomic) LWAuthStep stepId;

@end
