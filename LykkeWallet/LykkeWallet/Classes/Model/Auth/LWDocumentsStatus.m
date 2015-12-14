//
//  LWDocumentsStatus.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWDocumentsStatus.h"


@implementation LWDocumentsStatus


#pragma mark - Root

- (instancetype)initWithJSON:(id)json {
    self = [super init];
    if (self) {
        _selfie = [json[@"Selfie"] boolValue];
        _idCard = [json[@"IdCard"] boolValue];
        _proofOfAddress = [json[@"ProofOfAddress"] boolValue];
    }
    return self;
}


#pragma mark - Properties

- (BOOL)isDocumentRequired {
    return (self.selfie || self.idCard || self.proofOfAddress);
}

@end
