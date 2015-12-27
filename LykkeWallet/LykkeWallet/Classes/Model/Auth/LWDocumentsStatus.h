//
//  LWDocumentsStatus.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWJSONObject.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KYCDocumentType) {
    KYCDocumentTypeSelfie,
    KYCDocumentTypeIdCard,
    KYCDocumentTypeProofOfAddress
};


@interface LWDocumentsStatus : LWJSONObject {
    
}

@property (readonly, nonatomic) BOOL selfie;
@property (readonly, nonatomic) BOOL idCard;
@property (readonly, nonatomic) BOOL proofOfAddress;
// utils
@property (readonly, nonatomic) BOOL isSelfieUploaded;
@property (readonly, nonatomic) BOOL isIdCardUploaded;
@property (readonly, nonatomic) BOOL isPOAUploaded;
@property (readonly, nonatomic) NSNumber *documentTypeRequired;


#pragma mark - Utils

- (void)setTypeUploaded:(KYCDocumentType)type;

@end
