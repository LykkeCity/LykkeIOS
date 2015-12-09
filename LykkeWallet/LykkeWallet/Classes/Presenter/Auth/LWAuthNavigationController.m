//
//  LWAuthNavigationController.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthNavigationController.h"
#import "LWAuthEntryPointPresenter.h"
#import "LWAuthPINPresenter.h"
#import "LWAuthPINSuccessPresenter.h"
#import "LWRegisterProfileDataPresenter.h"
#import "LWRegisterCameraPresenter.h"
#import "LWRegisterVerifyingPresenter.h"


@interface LWAuthNavigationController () {
    
}

@end


@implementation LWAuthNavigationController


#pragma mark - Root

- (instancetype)init {    
    return [super initWithRootViewController:[LWAuthEntryPointPresenter new]];
}


#pragma mark - Common

- (void)navigateToStep:(LWAuthStep)step {
    // ...
}

@end
