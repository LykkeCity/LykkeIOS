//
//  LWAuthNavigationController.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKNavigationController.h"
#import "LWAuthStepPresenter.h"


@interface LWAuthNavigationController : TKNavigationController {
    
}

#pragma mark - Common

- (void)navigateToStep:(LWAuthStep)step;

@end
