//
//  LWRegisterBasePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 20.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterBasePresenter.h"
#import "LWTextField.h"


@interface LWRegisterBasePresenter () <LWTextFieldDelegate> {
    LWTextField *textField;
}

@property (weak, nonatomic) IBOutlet TKContainer *textContainer;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end


@implementation LWRegisterBasePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"title.register");

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
    
    [textField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // check button state
    [self validateProceedButtonState];
}

- (IBAction)nextClicked:(id)sender {
    [self goNext];
}

- (void)goNext {
    
}

- (NSString *)fieldPlaceholder {
    return @"";
}

- (BOOL)validateInput:(NSString *)input {
    return NO;
}

#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textFieldInput {
    if (!self.isVisible) { // prevent from being processed if controller is not presented
        return;
    }
    
    textField.valid = [self validateInput:textField.text];
    // check button state
    [self validateProceedButtonState];
}


#pragma mark - Utils

- (void)validateProceedButtonState {
    BOOL canProceed = textField.isValid;
    
    NSString *proceedImage = (canProceed) ? @"ButtonOK" : @"ButtonOKInactive";
    UIColor *proceedColor = (canProceed) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    BOOL enabled = (canProceed);
    
    [self.nextButton setBackgroundImage:[UIImage imageNamed:proceedImage] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:proceedColor forState:UIControlStateNormal];
    self.nextButton.enabled = enabled;
}

@end
