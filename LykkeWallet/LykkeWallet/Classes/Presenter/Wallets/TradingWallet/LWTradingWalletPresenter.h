//
//  LWTradingWalletPresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 27.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthComplexPresenter.h"


@interface LWTradingWalletPresenter : LWAuthComplexPresenter {
    
}


#pragma mark - Properties

@property (copy,   nonatomic) NSString *assetId;
@property (copy,   nonatomic) NSString *assetName;
@property (copy,   nonatomic) NSString *issuerId;

@end
