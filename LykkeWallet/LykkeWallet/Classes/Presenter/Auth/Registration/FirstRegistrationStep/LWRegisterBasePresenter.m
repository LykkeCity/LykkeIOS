//
//  LWRegisterBasePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterBasePresenter.h"
#import "LWAuthNavigationController.h"
#import "LWTextField.h"
#import "LWValidator.h"


@interface LWRegisterBasePresenter () <LWTextFieldDelegate> {
    LWTextField *textField;
}

@property (weak, nonatomic) IBOutlet TKContainer *textContainer;
@property (weak, nonatomic) IBOutlet UIButton    *nextButton;

@end


@implementation LWRegisterBasePresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registrationInfo = [LWRegistrationData new];
    
    self.title = Localize(@"title.register");

    textField = [LWTextField createTextFieldForContainer:self.textContainer
                                         withPlaceholder:self.fieldPlaceholder];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.delegate = self;
    [self configureTextField:textField];
    
    [textField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // check button state
    [LWValidator setButton:self.nextButton enabled:[self canProceed]];
}

- (IBAction)nextClicked:(id)sender {
    [self proceedToNextStep];
}


#pragma mark - Navigation

- (void)proceedToNextStep {
    // copy data to model
    [self prepareNextStepData:textField.text];
    
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:[self nextStep]
     preparationBlock:^(LWAuthStepPresenter *presenter) {
         LWRegisterBasePresenter *nextPresenter = (LWRegisterBasePresenter *)presenter;
         nextPresenter.registrationInfo = [self.registrationInfo copy];
     }];
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


#pragma mark - Properties

- (NSString *)fieldPlaceholder {
    return @"";
}

- (LWAuthStep)nextStep {
    return LWAuthStepEntryPoint;
}

- (BOOL)canProceed {
    return textField.isValid;
}


#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textFieldInput {
    if (!self.isVisible) { // prevent from being processed if controller is not presented
        return;
    }
    textField.valid = [self validateInput:textField.text];
    // check button state
    [LWValidator setButton:self.nextButton enabled:self.canProceed];
}

@end
