//
//  LWPacketLykkeWallet.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 26.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"


@interface LWPacketLykkeWallet : LWAuthorizePacket {
    
}
// out
@property (readonly, nonatomic) NSArray  *wallets;
@property (readonly, nonatomic) NSNumber *equity;

@end
