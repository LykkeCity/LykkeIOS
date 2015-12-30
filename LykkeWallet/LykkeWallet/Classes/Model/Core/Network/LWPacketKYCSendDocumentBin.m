//
//  LWPacketKYCSendDocumentBin.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 30.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketKYCSendDocumentBin.h"


@implementation LWPacketKYCSendDocumentBin


#pragma mark - LWPacket

- (NSString *)urlRelative {
    NSString *docTypeString = nil;
    
    switch (self.docType) {
        case KYCDocumentTypeIdCard: {
            docTypeString = @"IdCard";
            break;
        }
        case KYCDocumentTypeProofOfAddress: {
            docTypeString = @"ProofOfAddress";
            break;
        }
        case KYCDocumentTypeSelfie: {
            docTypeString = @"Selfie";
            break;
        }
    }
    
    return [NSString stringWithFormat:@"KycDocumentsBin?type=%@&ext=jpeg", docTypeString];
}

- (void (^)(id<AFMultipartFormData>))bodyConstructionBlock {
    return ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:self.imageJPEGRepresentation
                                    name:@"image"];
    };
}

@end
