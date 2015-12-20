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
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end


@implementation LWRegisterBasePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registrationInfo = [LWRegistrationData new];
    
    self.title = Localize(@"title.register");

#warning TODO: move to common function
    // init fields
    LWTextField *(^createField)(TKContainer *, NSString *) = ^LWTextField *(TKContainer *container, NSString *placeholder) {
        LWTextField *f = [LWTextField new];
        //        f.delegate = self;
        f.keyboardType = UIKeyboardTypeASCIICapable;
        f.placeholder = placeholder;
        [container attach:f];
        
        return f;
    };
    
    textField = createField(self.textContainer, [self fieldPlaceholder]);
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
    [self goNext];
}

- (void)goNext {
    // copy data to model
    [self prepareNextStepData:textField.text];
    
    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:[self nextStep]
     preparationBlock:^(LWAuthStepPresenter *presenter) {
         LWRegisterBasePresenter *nextPresenter = (LWRegisterBasePresenter *)presenter;
         nextPresenter.registrationInfo = [self.registrationInfo copy];
     }];
}

- (LWAuthStep)nextStep {
    return LWAuthStepEntryPoint;
}

- (void)prepareNextStepData:(NSString *)input {
    
}

- (NSString *)fieldPlaceholder {
    return @"";
}

- (BOOL)validateInput:(NSString *)input {
    return NO;
}

- (void)configureTextField:(LWTextField *)textField {
    
}


#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textFieldInput {
    if (!self.isVisible) { // prevent from being processed if controller is not presented
        return;
    }
    
    textField.valid = [self validateInput:textField.text];
    // check button state
    [LWValidator setButton:self.nextButton enabled:[self canProceed]];
}


#pragma mark - Utils

- (BOOL)canProceed {
    BOOL canProceed = textField.isValid;
    return canProceed;
}

@end
