//
//  LWPacketKYCStatusGet.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWCookiePacket.h"


@interface LWPacketKYCStatusGet : LWCookiePacket {
    
}
// out
@property (readonly, nonatomic) NSString *status;

@end
