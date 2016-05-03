//
//  LWSMSCodeStepPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 03.05.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWSMSCodeStepPresenter.h"
#import "LWTextField.h"
#import "LWValidator.h"
#import "LWConstants.h"
#import "TKButton.h"


@interface LWSMSCodeStepPresenter ()<LWTextFieldDelegate> {
    LWTextField *codeTextField;
}

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet TKContainer *codeContainer;
@property (weak, nonatomic) IBOutlet TKButton    *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel     *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton    *pasteButton;

@end


@implementation LWSMSCodeStepPresenter

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = Localize(@"register.title");
    
    // init email field
    codeTextField = [LWTextField new];
    codeTextField.delegate = self;
    codeTextField.keyboardType = UIKeyboardTypeDefault;
    codeTextField.placeholder = Localize(@"register.sms.code.placeholder");

    codeTextField.viewMode = UITextFieldViewModeNever;
    [self.codeContainer attach:codeTextField];
    
    [self.codeContainer bringSubviewToFront:self.pasteButton];
    
#ifdef PROJECT_IATA
#else
    [self.confirmButton setGrayPalette];
#endif
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoClicked:)];
    [self.infoLabel setUserInteractionEnabled:YES];
    [self.infoLabel addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updatePasteButtonStatus];
}

- (void)localize {
    self.infoLabel.text = Localize(@"register.sms.help.info");
    self.titleLabel.text = [NSString stringWithFormat:Localize(@"register.sms.title"), self.email];

    
    [self.confirmButton setTitle:Localize(@"register.sms.confirm")
                        forState:UIControlStateNormal];
    
    [self.pasteButton setTitle:Localize(@"register.sms.code.paste")
                      forState:UIControlStateNormal];
}

- (void)colorize {
    UIColor *color = [UIColor colorWithHexString:kMainElementsColor];
    [self.infoLabel setTextColor:color];
}

#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textField {
    // prevent from being processed if controller is not presented
    if (!self.isVisible) {
        return;
    }
    
    [self updatePasteButtonStatus];
}

#pragma mark - Outlets

- (IBAction)confirmClicked:(id)sender {
    //LWWithdrawInputPresenter *presenter = [LWWithdrawInputPresenter new];
    //presenter.assetId = self.assetId;
    //presenter.bitcoinString = bitcoinTextField.text;
    //[self.navigationController pushViewController:presenter animated:YES];
    
    
    //((LWRegisterBasePresenter *)presenter).registrationInfo.email = emailTextField.text;
}

- (IBAction)pasteClicked:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    codeTextField.text = [pasteboard string];
    
    [self updatePasteButtonStatus];
}

- (void)infoClicked:(id)sender {
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)nextStep {
    return LWAuthStepRegisterFullName;
}

- (LWAuthStep)stepId {
    return LWAuthStepSMSCode;
}


#pragma mark - Utils

- (BOOL)canProceed {
    BOOL canProceed = codeTextField.text.length > 0;
    return canProceed;
}

- (void)updatePasteButtonStatus {
    // check button state
    [LWValidator setButton:self.confirmButton enabled:[self canProceed]];
    self.pasteButton.hidden = [self canProceed];
}

@end
