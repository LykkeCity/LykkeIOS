//
//  LWAuthPINEnterPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 17.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthPINEnterPresenter.h"
#import "LWAuthNavigationController.h"
#import "ABPadLockScreen.h"
#import "TKPresenter+Loading.h"


@interface LWAuthPINEnterPresenter () <ABPadLockScreenViewControllerDelegate> {
    ABPadLockScreenViewController *pinController;
    
    NSString *pin;
    BOOL     pinDidValidOnServer;
}

@end


@implementation LWAuthPINEnterPresenter


#pragma mark - LWAuthStepPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // adjust pin controller frame
    if (!pinController) {
        pinController = [[ABPadLockScreenViewController alloc] initWithDelegate:self
                                                                     complexPin:NO];
        [pinController cancelButtonDisabled:YES];
        
        pinController.modalPresentationStyle = UIModalPresentationFullScreen;
        pinController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    if (!pin) {
        [self presentViewController:pinController animated:YES completion:nil];
    }
}

- (void)localize {
}

- (LWAuthStep)stepId {
    return LWAuthStepValidatePIN;
}


#pragma mark - ABPadLockScreenSetupViewControllerDelegate

- (BOOL)padLockScreenViewController:(ABPadLockScreenViewController *)controller validatePin:(NSString*)pin_ {

    [controller dismissViewControllerAnimated:YES completion:nil]; // dismiss
    [pinController clearPin]; // don't forget to clear PIN data
    // save pin
    pin = [pin_ copy];
    // request PIN setup
    [[LWAuthManager instance] requestPinSecurityGet:pin];
    
#warning TODO: sync get method
    return YES;
}

- (void)unlockWasSuccessfulForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    
    [((LWAuthNavigationController *)self.navigationController) setRootMainTabScreen];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    [((LWAuthNavigationController *)self.navigationController) logout];
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    [((LWAuthNavigationController *)self.navigationController) logout];
}

- (void)attemptsExpiredForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    [((LWAuthNavigationController *)self.navigationController) logout];
}


#pragma mark - LWAuthManagerDelegate

/*- (void)authManagerDidSetPin:(LWAuthManager *)manager {
    pinDidValidOnServer = YES;
    // hide masking view
}*/

@end
