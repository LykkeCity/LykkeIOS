//
//  LWDocumentsStatus.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWDocumentsStatus.h"

@implementation LWDocumentsStatus


- (instancetype)initWithJSON:(id)json {
    self = [super init];
    if (self) {
        _idCard = [json[@"IdCard"] boolValue];
        _proofOfAddress = [json[@"ProofOfAddress"] boolValue];
        _selfie = [json[@"Selfie"] boolValue];
    }
    return self;
}

@end
