//
//  LWPacketAuthentication.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacket.h"
#import "LWAuthenticationData.h"


@interface LWPacketAuthentication : LWPacket {
    
}
// in
@property (strong, nonatomic) LWAuthenticationData *authenticationData;
// out
@property (copy, nonatomic) NSString *token;

@end
