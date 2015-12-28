//
//  LWAuthSteps.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 27.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWDocumentsStatus.h"


typedef NS_ENUM(NSInteger, LWAuthStep) {
    LWAuthStepValidation,
    LWAuthStepEntryPoint,
    LWAuthStepAuthentication,
    LWAuthStepValidatePIN,
    
    LWAuthStepRegisterFullName,
    LWAuthStepRegisterPhone,
    LWAuthStepRegisterPassword,
    LWAuthStepRegisterConfirmPassword,
    
    LWAuthStepRegisterSelfie,
    LWAuthStepRegisterIdentity,
    LWAuthStepRegisterUtilityBill,
    LWAuthStepRegisterKYCSubmit,
    LWAuthStepRegisterKYCPending,
    LWAuthStepRegisterKYCInvalidDocuments,
    LWAuthStepRegisterKYCRestricted,
    LWAuthStepRegisterKYCSuccess,
    LWAuthStepRegisterPINSetup
};


@interface LWAuthSteps : NSObject {
    
}

+ (LWAuthStep)getNextDocumentByStatus:(LWDocumentsStatus *)status;
+ (KYCDocumentType)getDocumentTypeByStep:(LWAuthStep)step;
+ (NSString *)titleByStep:(LWAuthStep)step;

@end
