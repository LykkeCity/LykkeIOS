//
//  LWPacketKYCStatusGet.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacket.h"


@interface LWPacketKYCStatusGet : LWPacket {
    
}
// in
@property (copy, nonatomic) NSString *authCookie;
// out
@property (readonly, nonatomic) NSString *status;

@end
