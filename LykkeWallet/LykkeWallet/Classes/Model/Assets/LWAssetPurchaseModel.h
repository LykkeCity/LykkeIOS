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

@end
