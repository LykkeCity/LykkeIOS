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


@interface LWAuthEntryPointPresenter ()<LWTextFieldDelegate, LWTipsViewDelegate> {
    LWTextField *emailTextField;
    LWTipsView  *tipsView;
}

@property (weak, nonatomic) IBOutlet TKContainer *emailTextFieldContainer;
@property (weak, nonatomic) IBOutlet UIButton    *proceedButton;
@property (weak, nonatomic) IBOutlet TKContainer *tipsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsBottomConstraint;

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
}

- (void)localize {
    [self.proceedButton setTitle:[Localize(@"auth.signIn") uppercaseString]
                        forState:UIControlStateNormal];
}

- (void)colorize {
    NSString *proceedImage = (emailTextField.isValid) ? @"ButtonOK" : @"ButtonOKInactive";
    UIColor *proceedColor = (emailTextField.isValid) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    
    [self.proceedButton setBackgroundImage:[UIImage imageNamed:proceedImage] forState:UIControlStateNormal];
    [self.proceedButton setTitleColor:proceedColor forState:UIControlStateNormal];
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


#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textField {
    textField.valid = [LWValidator validateEmail:textField.text];
    // switch colors
    [self colorize];
    // send request
    if (textField.isValid) {
        [[LWAuthManager instance] requestEmailValidation:textField.text];
    }
}


#pragma mark - LWTipsViewDelegate

- (void)tipsViewDidPress:(LWTipsView *)view {
    // ...
}

@end
