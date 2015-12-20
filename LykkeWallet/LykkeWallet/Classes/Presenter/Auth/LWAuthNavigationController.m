//
//  LWAuthNavigationController.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthNavigationController.h"
#import "LWAuthEntryPointPresenter.h"

#import "LWRegisterBasePresenter.h"
#import "LWRegisterFullNamePresenter.h"
#import "LWRegisterPhonePresenter.h"
#import "LWRegisterPasswordPresenter.h"
#import "LWRegisterConfirmPasswordPresenter.h"

#import "LWAuthenticationPresenter.h"

#import "LWAuthPINEnterPresenter.h"
#import "LWRegisterProfileDataPresenter.h"
#import "LWRegisterCameraSelfiePresenter.h"
#import "LWKYCPendingPresenter.h"
#import "LWKYCInvalidDocumentsPresenter.h"
#import "LWKYCRestrictedPresenter.h"
#import "LWKYCSuccessPresenter.h"
#import "LWRegisterPINSetupPresenter.h"


@interface LWAuthNavigationController () {
    NSArray *classes;
    NSMutableDictionary<NSNumber *, LWAuthStepPresenter *> *activeSteps;
}

@end


@implementation LWAuthNavigationController


#pragma mark - Root

- (instancetype)init {
    self = [super initWithRootViewController:[LWAuthEntryPointPresenter new]];
    if (self) {
        _currentStep = LWAuthStepEntryPoint;
        
        classes = @[LWAuthEntryPointPresenter.class,
                    //LWAuthPINEnterPresenter.class,
                    LWAuthenticationPresenter.class,

                    LWRegisterFullNamePresenter.class,
                    LWRegisterPhonePresenter.class,
                    LWRegisterPasswordPresenter.class,
                    LWRegisterConfirmPasswordPresenter.class,
                    
                    LWRegisterCameraSelfiePresenter.class,
                    LWRegisterCameraPresenter.class,
                    LWRegisterCameraPresenter.class,
                    LWKYCPendingPresenter.class,
                    LWKYCInvalidDocumentsPresenter.class,
                    LWKYCRestrictedPresenter.class,
                    LWKYCSuccessPresenter.class,
                    LWRegisterPINSetupPresenter.class];
        activeSteps = [NSMutableDictionary new];
        activeSteps[@(self.currentStep)] = self.viewControllers.firstObject;
    }
    return self;
}


#pragma mark - Common

- (void)navigateToStep:(LWAuthStep)step preparationBlock:(LWAuthStepPushPreparationBlock)block {
    // check whether we can just unwind to step
    if ([activeSteps.allKeys containsObject:@(step)]) {
        [self popToViewController:activeSteps[@(step)] animated:YES];
    }
    else {
        // otherwise create new step presenter
        LWAuthStepPresenter *presenter = [classes[step] new];
        activeSteps[@(step)] = presenter;
        // prevent lazy view loading
        NSLog(@"PreventingLazyLoad: %@", presenter.view);
        // prepare to push if necessary
        if (block) {
            block(presenter);
        }
        [self pushViewController:presenter animated:YES];
    }
    // change current step
    _currentStep = step;
}

- (void)navigateWithKYCStatus:(NSString *)status withPinEntered:(BOOL)isPinEntered isAuthentication:(BOOL)isAuthentication {

    NSLog(@"KYC GetStatus: %@", status);

    if ([status isEqualToString:@"NeedToFillData"]) {
        [self navigateToStep:LWAuthStepRegisterKYCInvalidDocuments preparationBlock:nil];
    }
    else if ([status isEqualToString:@"RestrictedArea"]) {
        [self navigateToStep:LWAuthStepRegisterKYCRestricted preparationBlock:nil];
    }
    else if ([status isEqualToString:@"Ok"] && !isAuthentication) {
        [self navigateToStep:LWAuthStepRegisterKYCSuccess preparationBlock:nil];
    }
    else if ([status isEqualToString:@"Ok"] && isAuthentication) {
        if (isPinEntered) {
            #warning TODO: navigate to main screen
        }
        else  {
            [self navigateToStep:LWAuthStepRegisterPINSetup preparationBlock:nil];
        }
    }
    else {
        NSAssert(0, @"Unknown KYC status.");
    }
}


#pragma mark - UINavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *result = [super popViewControllerAnimated:animated];
    // clean steps
    for (NSNumber *key in activeSteps.allKeys) {
        if (![self.viewControllers containsObject:activeSteps[key]]) {
            [activeSteps removeObjectForKey:key];
        }
    }
    return result;
}

@end
