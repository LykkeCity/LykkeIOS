//
//  LWRegisterPhonePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterPhonePresenter.h"
#import "LWCountrySelectorPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterPhonePresenter () <UITextFieldDelegate, LWCountrySelectorPresenterDelegate> {
}

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation LWRegisterPhonePresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"title.register");
    [self.nextButton setTitle:Localize(@"register.phone.send")
                     forState:UIControlStateNormal];
    
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextField.delegate = self;
    self.codeTextField.text = @"+";
    
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextField.delegate = self;
    self.numberTextField.placeholder = Localize(@"register.phone.placeholder");

    [self.codeTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // check button state
    //[LWValidator setButton:self.nextButton enabled:[self canProceed]];
    
    self.observeKeyboardEvents = YES;
}

- (IBAction)nextClicked:(id)sender {
    //[self proceedToNextStep];
}

- (IBAction)countryClicked:(id)sender {
    LWCountrySelectorPresenter *presenter = [LWCountrySelectorPresenter new];
    presenter.delegate = self;
    [self.navigationController pushViewController:presenter animated:YES];
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


#pragma mark - Navigation

- (void)proceedToNextStep {
    // copy data to model
    /*[self prepareNextStepData:textField.text];
    
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:[self nextStep]
     preparationBlock:^(LWAuthStepPresenter *presenter) {
         LWRegisterBasePresenter *nextPresenter = (LWRegisterBasePresenter *)presenter;
         nextPresenter.registrationInfo = [self.registrationInfo copy];
     }];*/
}

- (void)prepareNextStepData:(NSString *)input {
    // override if necessary
}


#pragma mark - Properties

- (NSString *)fieldPlaceholder {
    return @"";
}

- (LWAuthStep)nextStep {
//#error TODO:
    return LWAuthStepRegisterPhone;
}

- (BOOL)canProceed {
    //return textField.isValid;
    return NO;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidChangeValue:(UITextField *)textFieldInput {
    //[self.textField addTarget:target
    //                   action:selector
    //         forControlEvents:UIControlEventEditingChanged];
    
    if (!self.isVisible) { // prevent from being processed if controller is not presented
        return;
    }
    //textField.valid = [self validateInput:textField.text];
    // check button state
    [LWValidator setButton:self.nextButton enabled:self.canProceed];
}


#pragma mark - LWCountrySelectorPresenterDelegate

- (void)countrySelected:(NSString *)name code:(NSString *)code prefix:(NSString *)prefix {
    self.codeTextField.text = prefix;
}

@end
