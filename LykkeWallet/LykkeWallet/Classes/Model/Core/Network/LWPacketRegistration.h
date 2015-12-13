//
//  LWPacketRegistration.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 11.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWCookiePacket.h"
#import "LWRegistrationData.h"


@interface LWPacketRegistration : LWCookiePacket {
    
}
// in
@property (strong, nonatomic) LWRegistrationData *registrationData;

@end
