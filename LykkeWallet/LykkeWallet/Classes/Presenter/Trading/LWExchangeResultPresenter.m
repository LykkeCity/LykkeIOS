//
//  LWExchangeResultPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeResultPresenter.h"


@interface LWExchangeResultPresenter () {
    
}

@end


@implementation LWExchangeResultPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


#pragma mark - Actions

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
