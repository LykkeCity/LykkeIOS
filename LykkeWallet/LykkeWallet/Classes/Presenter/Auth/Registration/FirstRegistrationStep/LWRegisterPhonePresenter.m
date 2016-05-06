//
//  LWRegisterPhonePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterPhonePresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterPhonePresenter () <LWTextFieldDelegate> {
    LWTextField *codeTextField;
    LWTextField *numberTextField;
}

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet TKContainer *countryCodeContainer;
@property (weak, nonatomic) IBOutlet TKContainer *countryNumberContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation LWRegisterPhonePresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"title.register");
    [self.nextButton setTitle:Localize(@"register.phone.send")
                     forState:UIControlStateNormal];
    
    codeTextField = [LWTextField createTextFieldForContainer:self.countryCodeContainer withPlaceholder:self.fieldPlaceholder];
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.delegate = self;
    [self configureTextField:codeTextField];
    [codeTextField becomeFirstResponder];
    
    numberTextField = [LWTextField createTextFieldForContainer:self.countryNumberContainer withPlaceholder:self.fieldPlaceholder];
    numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    numberTextField.delegate = self;
    [self configureTextField:numberTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // check button state
    [LWValidator setButton:self.nextButton enabled:[self canProceed]];
    
    self.observeKeyboardEvents = YES;
}

- (IBAction)nextClicked:(id)sender {
    //[self proceedToNextStep];
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


#pragma mark - Utils

- (BOOL)validateInput:(NSString *)input {
    return NO;
}

- (void)configureTextField:(LWTextField *)textField {
    // override if necessary
}

- (NSString *)textFieldString {
    //return textField.text;
    return nil;
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


#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textFieldInput {
    if (!self.isVisible) { // prevent from being processed if controller is not presented
        return;
    }
    //textField.valid = [self validateInput:textField.text];
    // check button state
    [LWValidator setButton:self.nextButton enabled:self.canProceed];
}

@end
