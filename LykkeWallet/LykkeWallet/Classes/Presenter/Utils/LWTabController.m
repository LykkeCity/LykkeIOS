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


@interface LWTabController ()<LWAuthManagerDelegate> {
    
}

@end


@implementation LWTabController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [LWAuthManager instance].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidNotAuthorized:(LWAuthManager *)manager {
    [((LWAuthNavigationController *)self.navigationController) logout];
}

@end
