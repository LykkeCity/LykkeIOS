//
//  TKNavigationController.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKNavigationController.h"


@interface TKNavigationController () {
    
}

@end


@implementation TKNavigationController


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
}

@end
