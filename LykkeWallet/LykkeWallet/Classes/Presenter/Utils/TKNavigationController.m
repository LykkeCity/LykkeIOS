//
//  TKNavigationController.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKNavigationController.h"
#import "UIColor+Generic.h"
#import "LWConstants.h"

@interface TKNavigationController () {
    
}

@end


@implementation TKNavigationController


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:[title uppercaseString]];
}

@end
