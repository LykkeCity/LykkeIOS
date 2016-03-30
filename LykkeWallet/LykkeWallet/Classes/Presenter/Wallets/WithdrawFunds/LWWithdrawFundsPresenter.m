//
//  LWWithdrawFundsPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 30.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWWithdrawFundsPresenter.h"
#import "LWQrCodeScannerPresenter.h"
#import "LWTextField.h"
#import "LWValidator.h"
#import "LWConstants.h"
#import "TKContainer.h"
#import "TKButton.h"


@interface LWWithdrawFundsPresenter () <LWTextFieldDelegate> {
    LWTextField *bitcoinTextField;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet TKContainer *qrCodeContainer;
@property (weak, nonatomic) IBOutlet UILabel     *qrCodeLabel;
@property (weak, nonatomic) IBOutlet TKButton    *proceedButton;
@property (weak, nonatomic) IBOutlet UILabel     *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton    *pasteButton;


#pragma mark - Utils

- (BOOL)canProceed;

@end


@implementation LWWithdrawFundsPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"withdraw.funds.title");
    
    
    // init email field
    bitcoinTextField = [LWTextField new];
    bitcoinTextField.delegate = self;
    bitcoinTextField.keyboardType = UIKeyboardTypeEmailAddress;
    bitcoinTextField.placeholder = Localize(@"withdraw.funds.wallet");
    [self.qrCodeContainer attach:bitcoinTextField];
    
#ifdef PROJECT_IATA
#else
    [self.proceedButton setGrayPalette];
#endif
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanClicked:)];
    [self.qrCodeLabel setUserInteractionEnabled:YES];
    [self.qrCodeLabel addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [LWValidator setButton:self.proceedButton enabled:[self canProceed]];
}

- (void)localize {
    self.infoLabel.text = Localize(@"withdraw.funds.info");
    self.titleLabel.text = Localize(@"withdraw.funds.address");
    self.qrCodeLabel.text = Localize(@"withdraw.funds.scan");
    
    [self.proceedButton setTitle:Localize(@"withdraw.funds.proceed")
                        forState:UIControlStateNormal];
    
    [self.pasteButton setTitle:Localize(@"withdraw.funds.paste")
                      forState:UIControlStateNormal];
}

- (void)colorize {
    UIColor *color = [UIColor colorWithHexString:kMainElementsColor];
    [self.qrCodeLabel setTextColor:color];
}

#pragma mark - LWTextFieldDelegate

- (void)textFieldDidChangeValue:(LWTextField *)textField {
    // prevent from being processed if controller is not presented
    if (!self.isVisible) {
        return;
    }

    // check button state
    bitcoinTextField.valid = [LWValidator validateQrCode:textField.text];
    [LWValidator setButton:self.proceedButton enabled:[self canProceed]];
}


#pragma mark - Outlets

- (IBAction)proceedClicked:(id)sender {
    
}

- (IBAction)pasteClicked:(id)sender {
    
}

- (IBAction)scanClicked:(id)sender {
    LWQrCodeScannerPresenter *presenter = [LWQrCodeScannerPresenter new];
    [self.navigationController pushViewController:presenter animated:YES];
}


#pragma mark - Utils

- (BOOL)canProceed {
    BOOL canProceed = bitcoinTextField.isValid;
    return canProceed;
}

@end
