//
//  LWTabController.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 08.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWTabController.h"
#import "LWAuthManager.h"
#import "LWAuthNavigationController.h"


@interface LWTabController () {
    
}

@end


@implementation LWTabController


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // workaround to prevent issues with displaying controllers simultaneously
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![LWAuthManager instance].isAuthorized) {
            [self presentViewController:[LWAuthNavigationController new] animated:NO completion:nil];
        }
    });
}

@end
