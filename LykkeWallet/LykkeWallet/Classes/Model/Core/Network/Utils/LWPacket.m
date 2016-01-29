//
//  LWPacket.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacket.h"
#import "LWKeychainManager.h"


@implementation LWPacket


#pragma mark - GDXRESTPacket

- (instancetype)initWithJSON:(id)json {
    return [super init]; // our root packet will not parse any input JSON
}

- (void)parseResponse:(id)response error:(NSError *)error {
    result = [response objectForKey:@"Result"];
    _reject = response[@"Error"];
    
    if (_reject && ![_reject isKindOfClass:[NSNull class]]) {
#warning TODO: as request by customer (temporarly)
        _reject = [response[@"Error"] mutableCopy];
        NSString *message = [_reject objectForKey:@"Message"];
        NSString *temp = [NSString stringWithFormat:@"%@%@ %@", [self urlBase], [self urlRelative], message];
        [_reject setObject:temp forKey:@"Message"];
    }
    
    _isRejected = (self.reject != nil) && ![self.reject isKindOfClass:NSNull.class];
}

- (NSString *)urlBase {
    NSString *address = [LWKeychainManager instance].address;
    NSString *addr = [NSString stringWithFormat:@"https://%@/api/", address];
    return addr;
}

- (NSString *)urlRelative {
    NSAssert(0, nil); // root packet has no relative URL
    return nil;
}

- (NSDictionary *)headers {
    return @{}; // no headers by default
}

- (NSDictionary *)params {
    return @{}; // no API method's input parameters by default
}

- (void (^)(id<AFMultipartFormData> formData))bodyConstructionBlock {
    return nil;
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypePOST; // for our server default HTTP method is POST
}

- (GDXRESTPacketOptions *)options {
    GDXRESTPacketOptions *options = [GDXRESTPacketOptions new];
    options.cacheAllowed = NO; // forbid cache
    options.silent = NO; // silent requests, see 'GDXRESTPacketOptions' explanation below
    options.repeatOnSuccess = NO; // should be auto-repeated on success
    options.repeatOnFailure = NO; // should be auto-repeated on failure
    options.timeout = 30; // request timeout
    
    return options;
}

- (GDXRESTOperationType)requestType {
    return ((self.type == GDXRESTPacketTypePOST)
            ? GDXRESTOperationTypeJSON // JSON for POST
            : GDXRESTOperationTypeHTTP); // HTTP for GET
}

- (GDXRESTOperationType)responseType {
    return GDXRESTOperationTypeJSON;
}

@end
