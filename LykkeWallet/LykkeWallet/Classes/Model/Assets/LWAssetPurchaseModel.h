//
//  LWAssetPurchaseModel.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWJSONObject.h"


@interface LWAssetPurchaseModel : LWJSONObject {
    
}


#pragma mark - Properties

@property (readonly, nonatomic) NSString *identity;
@property (readonly, nonatomic) NSString *orderType;
@property (readonly, nonatomic) NSNumber *volume;
@property (readonly, nonatomic) NSNumber *price;
@property (readonly, nonatomic) NSString *baseAsset;
@property (readonly, nonatomic) NSString *assetPair;
@property (readonly, nonatomic) NSString *blockchainId;
@property (readonly, nonatomic) BOOL      blockchainSettled;
@property (readonly, nonatomic) NSNumber *totalCost;
@property (readonly, nonatomic) NSNumber *commission;
@property (readonly, nonatomic) NSNumber *position;

@end
