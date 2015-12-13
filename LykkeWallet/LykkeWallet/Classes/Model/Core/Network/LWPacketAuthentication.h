//
//  LWPacketAuthentication.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWCookiePacket.h"
#import "LWAuthenticationData.h"


@interface LWPacketAuthentication : LWCookiePacket {
    
}
// in
@property (strong, nonatomic) LWAuthenticationData *authenticationData;

@end
