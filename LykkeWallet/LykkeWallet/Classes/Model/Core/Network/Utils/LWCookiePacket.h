//
//  LWCookiePacket.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 14.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacket.h"


@interface LWCookiePacket : LWPacket {
    
}
// in
@property (copy, nonatomic) NSString *authCookie;

@end
