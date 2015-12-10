//
//  LWAuthEntryPointPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthEntryPointPresenter.h"
#import "LWTextField.h"
#import "LWTipsView.h"
#import "LWValidator.h"
#import "LWAuthManager.h"

typedef NS_ENUM(NSInteger, LWAuthEntryPointNextStep) {
    LWAuthEntryPointNextStepNone,
    LWAuthEntryPointNextStepPIN,
    LWAuthEntryPointNextStepRegister
};


@interface LWAuthEntryPointPresenter ()<
    LWTextFieldDelegate,
    LWTipsViewDelegate,
    LWAuthManagerDelegate
> {
    LWTextField *emailTextField;
    LWTipsView  *tipsView;
    
    LWAuthEntryPointNextStep step;
}

@property (weak, nonatomic) IBOutlet TKContainer *emailTextFieldContainer;
@property (weak, nonatomic) IBOutlet UIButton    *proceedButton;
@property (weak, nonatomic) IBOutlet TKContainer *tipsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsBottomConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


#pragma mark - Utils

- (void)validateProceedButtonState;


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
    [self.emailTextFieldContainer attach:emailTextField];
    // init tips
    tipsView = [LWTipsView new];
    tipsView.delegate = self;
    [self.tipsContainer attach:tipsView];
    // keyboard closing on tap
    [self addKeyboardCloseTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // keyboard observing
    [self subscribeKeyboardNotifications];
    // check button state
    [self validateProceedButtonState];
    // managers
    [LWAuthManager instance].delegate = self;
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

- (void)validateProceedButtonState {
    BOOL canProceed = emailTextField.isValid && (step != LWAuthEntryPointNextStepNone);
    
    NSString *proceedImage = (canProceed) ? @"ButtonOK" : @"ButtonOKInactive";
    UIColor *proceedColor = (canProceed) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    BOOL enabled = (canProceed);
    
    [self.proceedButton setBackgroundImage:[UIImage imageNamed:proceedImage] forState:UIControlStateNormal];
    [self.proceedButton setTitleColor:proceedColor forState:UIControlStateNormal];
    self.proceedButton.enabled = enabled;
}


#pragma mark - Actions

- (void)proceedButtonClick:(id)sender {
    switch (step) {
        case LWAuthEntryPointNextStepPIN: {
            NSLog(@"goto PIN");
            break;
        }
        case LWAuthEntryPointNextStepRegister: {
            NSLog(@"goto REGISTER");
            break;
        }
        default: {
            NSLog(@"no action");
            break;
        }
    }
}


#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textField {
    emailTextField.valid = [LWValidator validateEmail:textField.text];
    
    if (emailTextField.isValid) {
        // reset next step
        step = LWAuthEntryPointNextStepNone;
        // check button state
        [self validateProceedButtonState];
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

- (void)authManager:(LWAuthManager *)manager didCheckEmail:(BOOL)isRegistered {
    [self.activityView stopAnimating];
    
    if (isRegistered) {
        step = LWAuthEntryPointNextStepPIN;
        [self.proceedButton setTitle:[Localize(@"auth.login") uppercaseString]
                            forState:UIControlStateNormal];
    }
    else {
        step = LWAuthEntryPointNextStepRegister;
        [self.proceedButton setTitle:[Localize(@"auth.signup") uppercaseString]
                            forState:UIControlStateNormal];
    }
    // check button state
    [self validateProceedButtonState];
}

- (void)authManager:(LWAuthManager *)manager didFail:(NSDictionary *)reject {
    [self.activityView stopAnimating];
    
    step = LWAuthEntryPointNextStepRegister;
    // check button state
    [self validateProceedButtonState];
}

@end
