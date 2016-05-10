//
//  LWPacketGraphRates.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.05.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"


@interface LWPacketGraphRates : LWAuthorizePacket {
    
}
// in
@property (copy, nonatomic) NSString *period;
@property (copy, nonatomic) NSString *assetId;
@property (copy, nonatomic) NSNumber *points;
// out
@property (strong, nonatomic) NSString *dateTime;
// Array of LWGraphPeriodModel
@property (strong, nonatomic) NSArray  *rates;

@end
