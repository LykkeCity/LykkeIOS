//
//  LWWalletFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 31.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWWalletFormPresenter.h"
#import "LWAuthManager.h"
#import "LWConstants.h"
#import "UIColor+Generic.h"


@interface LWWalletFormPresenter ()<LWAuthManagerDelegate> {
    UIColor *navigationTintColor;
}

@end


@implementation LWWalletFormPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    navigationTintColor = self.navigationController.navigationBar.barTintColor;

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"D6D6D6"]];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidCardAdd:(LWAuthManager *)manager {
    NSLog(@"CARD ADDED");
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    NSLog(@"CARD ADD FAILED");
}

@end
