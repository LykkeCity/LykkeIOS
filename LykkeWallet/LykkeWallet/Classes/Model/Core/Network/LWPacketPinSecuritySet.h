//
//  LWPacketPinSecuritySet.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWCookiePacket.h"


@interface LWPacketPinSecuritySet : LWCookiePacket {
    
}
// in
@property (copy, nonatomic) NSString *pin;

@end
