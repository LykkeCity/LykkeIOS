//
//  LWWalletFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 31.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWWalletFormPresenter.h"
#import "LWAuthManager.h"
#import "LWTextField.h"
#import "LWConstants.h"
#import "LWBankCardsData.h"
#import "UIColor+Generic.h"


@interface LWWalletFormPresenter ()<LWAuthManagerDelegate> {
    UIColor *navigationTintColor;
    LWTextField *cardNumberTextField;
    LWTextField *cardExpireTextField;
    LWTextField *cardOwnerTextField;
    LWTextField *cardCodeTextField;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIView *bankCardsView;
@property (weak, nonatomic) IBOutlet TKContainer *cardNumberContainer;
@property (weak, nonatomic) IBOutlet TKContainer *cardExpireContainer;
@property (weak, nonatomic) IBOutlet TKContainer *cardOwnerContainer;
@property (weak, nonatomic) IBOutlet TKContainer *cardCodeContainer;


#pragma mark - Utils

- (void)createTextFields;

@end


@implementation LWWalletFormPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
  
    // setup no-title back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [LWAuthManager instance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = navigationTintColor;

    [super viewWillDisappear:animated];
}


#pragma mark - Setup

- (void)localize {
    self.title = Localize(@"wallets.cardform.title");
}

- (void)colorize {
    // detect color depends on bank cards list
    UIColor *color = (self.bankCards && self.bankCards.count > 0 ? [UIColor colorWithHexString:kMainGrayElementsColor] : [UIColor colorWithHexString:kMainWhiteElementsColor]);
    
    navigationTintColor = self.navigationController.navigationBar.barTintColor;
    [self.navigationController.navigationBar setBarTintColor:color];
    self.bankCardsView.backgroundColor = color;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidCardAdd:(LWAuthManager *)manager {
    NSLog(@"CARD ADDED");
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    NSLog(@"CARD ADD FAILED");
}


#pragma mark - Utils

- (void)createTextFields {
    // card number
    cardNumberTextField = [LWTextField
                           createTextFieldForContainer:self.cardNumberContainer withPlaceholder:Localize(@"wallets.cardform.card.number.placeholder")];
    cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    //cardNumberTextField.delegate = self;
    //[self configureTextField:textField];
    
    // card expiration date
    cardExpireTextField = [LWTextField
                           createTextFieldForContainer:self.cardExpireContainer withPlaceholder:Localize(@"wallets.cardform.card.expire.placeholder")];
    cardExpireTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    // card owner name
    cardOwnerTextField = [LWTextField
                          createTextFieldForContainer:self.cardOwnerContainer withPlaceholder:Localize(@"wallets.cardform.card.owner.placeholder")];
    cardOwnerTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    // cvc card code
    cardCodeTextField = [LWTextField
                         createTextFieldForContainer:self.cardCodeContainer withPlaceholder:Localize(@"wallets.cardform.card.code.placeholder")];
    cardCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

@end
