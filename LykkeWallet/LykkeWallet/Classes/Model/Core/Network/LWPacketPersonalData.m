//
//  LWPacketPersonalData.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 26.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketPersonalData.h"


@implementation LWPacketPersonalData


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    _fullName = result[@"FullName"];
    _email = result[@"Email"];
    _phone = result[@"Phone"];
}

- (NSString *)urlRelative {
    return @"PersonalData";
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypeGET;
}

@end
