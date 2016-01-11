//
//  LWPacketBuySellAsset.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"


@class LWAssetDealModel;


@interface LWPacketBuySellAsset : LWAuthorizePacket {
    
}
// in
@property (copy, nonatomic) NSString *baseAsset;
@property (copy, nonatomic) NSString *assetPair;
@property (copy, nonatomic) NSNumber *volume;
@property (copy, nonatomic) NSNumber *rate;
// out
@property (readonly, nonatomic) LWAssetDealModel *deal;

@end
