//
//  LWPacketAccountExist.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 10.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketAccountExist.h"


@implementation LWPacketAccountExist


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    NSLog(response);
}

- (NSString *)urlRelative {
    return @"AccountExist";
}

- (NSDictionary *)params {
    return @{@"email" : self.email};
}

- (GDXRESTOperationType)responseType {
    return GDXRESTOperationTypeHTTP;
}

@end
