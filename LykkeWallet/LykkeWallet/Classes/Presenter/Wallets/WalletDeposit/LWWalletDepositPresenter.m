//
//  LWWalletDepositPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 02.02.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWWalletDepositPresenter.h"


@interface LWWalletDepositPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation LWWalletDepositPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"wallets.funds.title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL* nsUrl = [NSURL URLWithString:self.url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.webView loadRequest:request];
}

@end
