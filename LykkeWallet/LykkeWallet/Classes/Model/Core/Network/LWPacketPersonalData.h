//
//  LWPacketPersonalData.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 26.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"


@interface LWPacketPersonalData : LWAuthorizePacket {
    
}
// out
@property (readonly, nonatomic) NSString *fullName;
@property (readonly, nonatomic) NSString *email;
@property (readonly, nonatomic) NSString *phone;

@end
