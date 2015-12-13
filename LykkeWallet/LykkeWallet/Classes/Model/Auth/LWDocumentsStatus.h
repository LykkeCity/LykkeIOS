//
//  LWDocumentsStatus.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KYCDocumentType) {
    KYCDocumentTypeSelfie,
    KYCDocumentTypeIdCard,
    KYCDocumentTypeProofOfAddress
};


@interface LWDocumentsStatus : NSObject {
    
}

@property (readonly, nonatomic) BOOL selfie;
@property (readonly, nonatomic) BOOL idCard;
@property (readonly, nonatomic) BOOL proofOfAddress;

@end
