//
//  LWExchangeFormPresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthPresenter.h"


@class LWAssetPairModel;


@interface LWExchangeFormPresenter : LWAuthPresenter {
    
}

@property (assign, nonatomic) LWAssetPairModel *assetPair;

@end
