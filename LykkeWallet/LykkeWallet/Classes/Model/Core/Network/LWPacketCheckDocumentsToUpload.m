//
//  LWPacketCheckDocumentsToUpload.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 12.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketCheckDocumentsToUpload.h"


@implementation LWPacketCheckDocumentsToUpload


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    _idCard = [result[@"IdCard"] boolValue];
    _proofOfAddress = [result[@"ProofOfAddress"] boolValue];
    _selfie = [result[@"Selfie"] boolValue];
}

- (NSString *)urlRelative {
    return @"CheckDocumentsToUpload";
}

- (NSDictionary *)headers {
    if (self.authCookie) {
        return @{@"Cookie" : self.authCookie};
    }
    return [super headers];
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypeGET;
}

@end
