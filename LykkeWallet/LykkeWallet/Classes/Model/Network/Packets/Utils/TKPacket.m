//
//  TKPacket.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPacket.h"


@implementation TKPacket


#pragma mark - GDXRETKPacket

- (instancetype)initWithJSON:(id)json {
    return [super init]; // our root packet will not parse any input JSON
}

- (void)parseResponse:(id)response error:(NSError *)error {
    // empty
}

- (NSString *)urlBase {
    return @"http://yourservice.com/api/";
}

- (NSString *)urlRelative {
    NSAssert(0, nil); // root packet has no relative URL
    return nil;
}

- (NSArray *)headers {
    return @[]; // no headers by default
}

- (NSDictionary *)params {
    return @{}; // no API method's input parameters by default
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypePOST; // for our server default HTTP method is POTK
}

- (GDXRESTPacketOptions *)options {
    GDXRESTPacketOptions *options = [GDXRESTPacketOptions new];
    options.cacheAllowed = NO; // forbid cache
    options.silent = NO; // silent requests, see 'GDXRETKPacketOptions' explanation below
    options.repeatOnSuccess = NO; // should be auto-repeated on success
    options.repeatOnFailure = NO; // should be auto-repeated on failure
    options.timeout = 30; // request timeout
    
    return options;
}

- (GDXRESTOperationType)requestType {
    return ((self.type == GDXRESTPacketTypePOST)
            ? GDXRESTOperationTypeJSON // JSON for POTK
            : GDXRESTOperationTypeHTTP); // HTTP for GET
}

- (GDXRESTOperationType)responseType {
    return GDXRESTOperationTypeJSON; // default response type is HTTP
}

@end
