//
//  LWAuthEntryPointPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthEntryPointPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWTipsView.h"
#import "LWValidator.h"
#import "LWAuthManager.h"
#import "LWRegisterBasePresenter.h"
#import "LWAuthenticationPresenter.h"
#import "LWUrlAddressPresenter.h"
#import "ABPadLockScreen.h"

typedef NS_ENUM(NSInteger, LWAuthEntryPointNextStep) {
    LWAuthEntryPointNextStepNone,
    LWAuthEntryPointNextStepLogin,
    LWAuthEntryPointNextStepRegister
};


@interface LWAuthEntryPointPresenter ()<
    LWTextFieldDelegate,
    LWTipsViewDelegate,
    ABPadLockScreenSetupViewControllerDelegate
> {
    LWTextField *emailTextField;
    LWTipsView  *tipsView;
    
    LWAuthEntryPointNextStep step;
}

@property (weak, nonatomic) IBOutlet TKContainer *emailTextFieldContainer;
@property (weak, nonatomic) IBOutlet UIButton    *proceedButton;
@property (weak, nonatomic) IBOutlet UIButton    *chooseServerButton;
@property (weak, nonatomic) IBOutlet TKContainer *tipsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsBottomConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


#pragma mark - Actions

- (IBAction)proceedButtonClick:(id)sender;

@end


@implementation LWAuthEntryPointPresenter


#pragma mark - TKPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init email field
    emailTextField = [LWTextField new];
    emailTextField.delegate = self;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.placeholder = Localize(@"auth.email");
    [self.emailTextFieldContainer attach:emailTextField];
    // init tips
    tipsView = [LWTipsView new];
    tipsView.delegate = self;
    [self.tipsContainer attach:tipsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // keyboard observing
    self.observeKeyboardEvents = YES;
    // check button state
    [LWValidator setButton:self.proceedButton enabled:[self canProceed]];
    
#ifdef TEST
    self.chooseServerButton.hidden = NO;
#else
    self.chooseServerButton.hidden = YES;
#endif
}

#ifdef PROJECT_IATA
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#endif

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self textFieldDidChangeValue:emailTextField];
}

- (void)localize {
    [self.proceedButton setTitle:[Localize(@"auth.signup") uppercaseString]
                        forState:UIControlStateNormal];
}

- (void)observeKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.tipsBottomConstraint setConstant:frame.size.height];
    [self animateConstraintChanges];
}

- (void)observeKeyboardWillHideNotification:(NSNotification *)notification {
    [self.tipsBottomConstraint setConstant:0];
    [self animateConstraintChanges];
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepEntryPoint;
}


#pragma mark - Utils

- (BOOL)canProceed {
    BOOL canProceed = emailTextField.isValid && (step != LWAuthEntryPointNextStepNone);
    return canProceed;
}


#pragma mark - Actions

- (void)proceedButtonClick:(id)sender {
    LWAuthNavigationController *nav = (LWAuthNavigationController *)self.navigationController;
    
    switch (step) {
        case LWAuthEntryPointNextStepLogin: {
            [nav navigateToStep:LWAuthStepAuthentication
               preparationBlock:^(LWAuthStepPresenter *presenter) {
                ((LWAuthenticationPresenter *)presenter).email = emailTextField.text;
            }];
            break;
        }
        case LWAuthEntryPointNextStepRegister: {
            [nav navigateToStep:LWAuthStepRegisterFullName
               preparationBlock:^(LWAuthStepPresenter *presenter) {
                   ((LWRegisterBasePresenter *)presenter).registrationInfo.email = emailTextField.text;
               }];
            break;
        }
        default: {
            NSAssert(0, @"Invalid case.");
            break;
        }
    }
}

- (IBAction)proceedChooseServerClick:(id)sender {
    LWUrlAddressPresenter *address = [LWUrlAddressPresenter new];
    [self.navigationController pushViewController:address animated:YES];
}


#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textField {
    if (!self.isVisible) { // prevent from being processed if controller is not presented
        return;
    }
    emailTextField.valid = [LWValidator validateEmail:textField.text];
    // reset next step
    step = LWAuthEntryPointNextStepNone;
    // check button state
    [LWValidator setButton:self.proceedButton enabled:[self canProceed]];
    
    if (emailTextField.isValid) {
        // show activity
        [self.activityView startAnimating];
        // send request
        [[LWAuthManager instance] requestEmailValidation:emailTextField.text];
    }
}


#pragma mark - LWTipsViewDelegate

- (void)tipsViewDidPress:(LWTipsView *)view {
    // ...
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didCheckRegistration:(BOOL)isRegistered email:(NSString *)email {
    [self.activityView stopAnimating];
    
    if (isRegistered) {
        step = LWAuthEntryPointNextStepLogin;
        [self.proceedButton setTitle:[Localize(@"auth.login") uppercaseString]
                            forState:UIControlStateNormal];
    }
    else {
        step = LWAuthEntryPointNextStepRegister;
        [self.proceedButton setTitle:[Localize(@"auth.signup") uppercaseString]
                            forState:UIControlStateNormal];
    }
    // check button state
    [LWValidator setButton:self.proceedButton enabled:[self canProceed]];
    
    // request again if email changed
    if (![email isEqualToString:emailTextField.text]) {
        [self textFieldDidChangeValue:emailTextField];
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self.activityView stopAnimating];
    
    step = LWAuthEntryPointNextStepRegister;
    // check button state
    [LWValidator setButton:self.proceedButton enabled:[self canProceed]];
}


#pragma mark - ABPadLockScreenViewControllerDelegate

- (void)padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)controller didSetPin:(NSString *)pin {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
