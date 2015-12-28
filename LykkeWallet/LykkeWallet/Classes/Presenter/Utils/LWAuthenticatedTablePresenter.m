//
//  LWAuthenticatedTablePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 29.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthenticatedTablePresenter.h"
#import "LWAuthNavigationController.h"


@interface LWAuthenticatedTablePresenter () {
    
}

@end


@implementation LWAuthenticatedTablePresenter


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidNotAuthorized:(LWAuthManager *)manager {
    [((LWAuthNavigationController *)self.navigationController) logout];
}

@end
