//
//  LWExchangeFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeFormPresenter.h"
#import "LWAssetPairModel.h"
#import "UIViewController+Navigation.h"


@interface LWExchangeFormPresenter () {
    
}

@end


@implementation LWExchangeFormPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.assetPair.name;
    
    [self setBackButton];
}

@end
