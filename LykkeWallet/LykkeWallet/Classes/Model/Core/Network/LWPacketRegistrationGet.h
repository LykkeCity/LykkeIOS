//
//  LWPacketRegistrationGet.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 21.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"


@interface LWPacketRegistrationGet : LWAuthorizePacket {
    
}
// out
@property (readonly, nonatomic) NSString *status;
@property (readonly, nonatomic) BOOL isPinEntered;

@end
