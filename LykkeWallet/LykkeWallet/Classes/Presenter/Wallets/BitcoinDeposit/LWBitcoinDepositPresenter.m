//
//  LWBitcoinDepositPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 15.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWBitcoinDepositPresenter.h"
#import "TKButton.h"
#import "LWConstants.h"
#import "UIViewController+Navigation.h"


@interface LWBitcoinDepositPresenter () {
    UIColor *navigationTintColor;
}

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bitcoinHashLabel;
@property (nonatomic, weak) IBOutlet TKButton *copyingButton;
@property (nonatomic, weak) IBOutlet TKButton *emailButton;

@end

@implementation LWBitcoinDepositPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"wallets.bitcoin.deposit");
    
    [self setBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
#ifdef PROJECT_IATA
#else
    [self.copyingButton setGrayPalette];
#endif
}

- (void)colorize {
    navigationTintColor = self.navigationController.navigationBar.barTintColor;
    
#ifdef PROJECT_IATA
#else
    UIColor *color = [UIColor colorWithHexString:kMainGrayElementsColor];
    [self.navigationController.navigationBar setBarTintColor:color];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = navigationTintColor;
    
    [super viewWillDisappear:animated];
}

@end
