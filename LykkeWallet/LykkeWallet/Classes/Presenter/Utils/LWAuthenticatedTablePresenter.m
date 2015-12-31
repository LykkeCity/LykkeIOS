//
//  LWAuthenticatedTablePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 31.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthenticatedTablePresenter.h"
#import "LWAuthManager.h"


@interface LWAuthenticatedTablePresenter ()<LWAuthManagerDelegate> {
    
}

@end


@implementation LWAuthenticatedTablePresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //management
    [LWAuthManager instance].delegate = self;
}

@end
