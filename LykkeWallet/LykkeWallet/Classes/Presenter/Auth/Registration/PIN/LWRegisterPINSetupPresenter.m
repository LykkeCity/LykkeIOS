//
//  LWRegisterPINSetupPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 17.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterPINSetupPresenter.h"
#import "ABPadLockScreen.h"


@interface LWRegisterPINSetupPresenter ()<ABPadLockScreenSetupViewControllerDelegate> {
    ABPadLockScreenSetupViewController *pinController;
    NSString *pin;
}

@property (weak, nonatomic) IBOutlet UIView *maskingView;

@end


@implementation LWRegisterPINSetupPresenter


#pragma mark - TKPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.maskingView.hidden = (pin != nil);
    // adjust pin controller frame
    if (!pinController) {
        pinController = [[ABPadLockScreenSetupViewController alloc] initWithDelegate:self
                                                                          complexPin:NO];
        [pinController cancelButtonDisabled:YES];
        
        pinController.modalPresentationStyle = UIModalPresentationFullScreen;
        pinController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    if (!pin) {
        [self presentViewController:pinController animated:YES completion:nil];
    }
}

- (LWAuthStep)stepId {
    return LWAuthStepRegisterPINSetup;
}


#pragma mark - ABPadLockScreenSetupViewControllerDelegate

- (void)padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)controller didSetPin:(NSString *)pin_ {
    pin = [pin_ copy];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
