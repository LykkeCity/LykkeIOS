//
//  LWRegisterFNPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterFullNamePresenter.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterFullNamePresenter ()  {
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation LWRegisterFullNamePresenter


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.observeKeyboardEvents = YES;
}


#pragma mark - Keyboard

- (void)observeKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    const CGFloat bottomMargin = 20;
    CGFloat bottomX = (self.scrollView.frame.origin.y
                       + self.nextButton.frame.origin.y
                       + self.nextButton.frame.size.height
                       + bottomMargin);
    if (bottomX > rect.size.height) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottomX - rect.size.height, 0);
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentInset.bottom);
    }
}

- (void)observeKeyboardWillHideNotification:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}


#pragma mark - LWRegisterBasePresenter

- (void)prepareNextStepData:(NSString *)input {
    self.registrationInfo.fullName = input;
}

- (BOOL)validateInput:(NSString *)input {
    return [LWValidator validateFullName:input];
}

- (NSString *)fieldPlaceholder {
    return Localize(@"register.fullName");
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)nextStep {
    return LWAuthStepRegisterPhone;
}

- (LWAuthStep)stepId {
    return LWAuthStepRegisterFullName;
}

@end
