//
//  LWPacketMarketOrder.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 11.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"


@class LWAssetPurchaseModel;


@interface LWPacketMarketOrder : LWAuthorizePacket {
    
}
// in
@property (assign, nonatomic) NSString *orderId;
// out
@property (readonly, nonatomic) LWAssetPurchaseModel* model;

@end
