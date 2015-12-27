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


#pragma mark - Utils

- (void)setTypeUploaded:(KYCDocumentType)type {
    switch (type) {
        case KYCDocumentTypeSelfie: {
            _isSelfieUploaded = YES;
            break;
        }
        case KYCDocumentTypeIdCard: {
            _isIdCardUploaded = YES;
            break;
        }
        case KYCDocumentTypeProofOfAddress: {
            _isPOAUploaded = YES;
            break;
        }
    }
}


#pragma mark - Properties

- (NSNumber *)documentTypeRequired {
    if (self.selfie && !self.isSelfieUploaded) {
        return @(KYCDocumentTypeSelfie);
    }
    if (self.idCard && !self.isIdCardUploaded) {
        return @(KYCDocumentTypeIdCard);
    }
    if (self.proofOfAddress && !self.isPOAUploaded) {
        return @(KYCDocumentTypeProofOfAddress);
    }
    return nil;
}

@end
