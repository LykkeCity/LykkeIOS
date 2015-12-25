//
//  LWAuthPINEnterPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 17.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthPINEnterPresenter.h"

#import <AFNetworking/AFNetworking.h>

#import "LWAuthNavigationController.h"
#import "ABPadLockScreen.h"
#import "LWPacketPinSecurityGet.h"
#import "UIViewController+Loading.h"


static int const kAllowedAttempts = 3;

@interface LWAuthPINEnterPresenter () <ABPadLockScreenViewControllerDelegate> {
    ABPadLockScreenViewController *pinController;
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
        [pinController setAllowedAttempts:kAllowedAttempts];

        pinController.modalPresentationStyle = UIModalPresentationFullScreen;
        pinController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        ABPadLockScreenView *view = (ABPadLockScreenView *)pinController.view;
        view.enterPasscodeLabel.text = Localize(@"ABPadLockScreen.pin.enter");
        
        pinController.validateBlock = ^BOOL(NSString *pin_) {

            // configure URL
            __block LWPacketPinSecurityGet *pack = [LWPacketPinSecurityGet new];
            pack.pin = [pin_ copy];
        
            NSURL *url = [NSURL URLWithString:pack.urlBase];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
                                             initWithBaseURL:url];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            NSDictionary *headers = [pack headers];
            for (NSString *key in headers.allKeys) {
                [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            }
            
            [manager GET:pack.urlRelative
                parameters:nil
                progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    [pack parseResponse:responseObject error:nil];
                    dispatch_semaphore_signal(semaphore);
                }
                failure:^(NSURLSessionTask *operation, NSError *error) {
                    pack = nil;
                    dispatch_semaphore_signal(semaphore);
                }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
            BOOL const result = (pack && pack.isPassed);
            return result;
        };
    }
    [self presentViewController:pinController animated:YES completion:nil];
}

- (void)localize {
}

- (LWAuthStep)stepId {
    return LWAuthStepValidatePIN;
}


#pragma mark - ABPadLockScreenSetupViewControllerDelegate

- (BOOL)padLockScreenViewController:(ABPadLockScreenViewController *)controller validatePin:(NSString*)pin {

    [controller dismissViewControllerAnimated:YES completion:nil]; // dismiss
    [pinController clearPin]; // don't forget to clear PIN data

    // validate pin
    [self setLoading:YES];
    BOOL const result = (controller.validateBlock ? controller.validateBlock(pin) : NO);
    [self setLoading:NO];

    return result;
}

- (void)unlockWasSuccessfulForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    
    [((LWAuthNavigationController *)self.navigationController) setRootMainTabScreen];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    [pinController clearPin];
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    [((LWAuthNavigationController *)self.navigationController) logout];
}

- (void)attemptsExpiredForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController {
    [((LWAuthNavigationController *)self.navigationController) logout];
}

@end
