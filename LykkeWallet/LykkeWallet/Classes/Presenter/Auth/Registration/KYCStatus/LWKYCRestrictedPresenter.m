//
//  LWKYCRestrictedPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 15.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCRestrictedPresenter.h"


@interface LWKYCRestrictedPresenter () {
    
}

@end


@implementation LWKYCRestrictedPresenter


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepRegisterKYCRestricted;
}

@end
