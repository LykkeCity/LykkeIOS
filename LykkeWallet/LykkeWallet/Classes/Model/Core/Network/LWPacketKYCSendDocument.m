//
//  LWPacketKYCSendDocument.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 12.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketKYCSendDocument.h"


@implementation LWPacketKYCSendDocument


#pragma mark - LWPacket

- (NSString *)urlRelative {
    return @"CheckDocumentsToUpload";
}

- (NSDictionary *)headers {
    if (self.authCookie) {
        return @{@"Cookie" : self.authCookie};
    }
    return [super headers];
}

- (NSDictionary *)params {
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
    return @{@"type" : docTypeString,
             @"ext" : @"jpeg"};
}

- (void (^)(id<AFMultipartFormData>))bodyConstructionBlock {
    return ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:self.imageJPEGRepresentation name:@"image"];
    };
}

@end
