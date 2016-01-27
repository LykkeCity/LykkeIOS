//
//  LWDocumentsStatus.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWDocumentsStatus.h"


@implementation LWDocumentsStatus


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        _selfie         = [json[@"Selfie"] boolValue];
        _idCard         = [json[@"IdCard"] boolValue];
        _proofOfAddress = [json[@"ProofOfAddress"] boolValue];
        
        // check which documents already uploaded
        _isSelfieUploaded = !_selfie;
        _isIdCardUploaded = !_idCard;
        _isPOAUploaded = !_proofOfAddress;
    }
    return self;
}


#pragma mark - Utils

- (void)setTypeUploaded:(KYCDocumentType)type withImage:(UIImage *)image {
    switch (type) {
        case KYCDocumentTypeSelfie: {
            _isSelfieUploaded = YES;
            self.selfieLastImage = [image copy];
            break;
        }
        case KYCDocumentTypeIdCard: {
            _isIdCardUploaded = YES;
            self.idCardLastImage = [image copy];
            break;
        }
        case KYCDocumentTypeProofOfAddress: {
            _isPOAUploaded = YES;
            self.poaLastImage = [image copy];
            break;
        }
    }
}

- (UIImage *)lastUploadedImageForType:(KYCDocumentType)type {
    switch (type) {
        case KYCDocumentTypeSelfie: {
            return _selfieLastImage;
        }
        case KYCDocumentTypeIdCard: {
            return _idCardLastImage;
        }
        case KYCDocumentTypeProofOfAddress: {
            return _poaLastImage;
        }
    }
    return nil;
}

- (void)resetTypeUploaded:(KYCDocumentType)type {
    switch (type) {
        case KYCDocumentTypeSelfie: {
            _isSelfieUploaded = NO;
            break;
        }
        case KYCDocumentTypeIdCard: {
            _isIdCardUploaded = NO;
            break;
        }
        case KYCDocumentTypeProofOfAddress: {
            _isPOAUploaded = NO;
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
