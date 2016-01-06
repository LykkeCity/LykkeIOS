//
//  LWExchangeBuyFormPresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 06.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthComplexPresenter.h"


@class LWAssetPairModel;
@class LWAssetPairRateModel;


@interface LWExchangeBuyFormPresenter : LWAuthComplexPresenter {
    
}


#pragma mark - Properties

@property (assign, nonatomic) LWAssetPairModel     *assetPair;
@property (assign, nonatomic) LWAssetPairRateModel *assetRate;

@end
