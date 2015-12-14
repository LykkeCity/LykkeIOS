//
//  LWAuthManager.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWNetAccessor.h"
#import "LWRegistrationData.h"
#import "LWAuthenticationData.h"
#import "LWPacketKYCSendDocument.h"

@class LWAuthManager;


@protocol LWAuthManagerDelegate<NSObject>
@optional
- (void)authManager:(LWAuthManager *)manager didFail:(NSDictionary *)reject;
- (void)authManager:(LWAuthManager *)manager didCheckEmail:(BOOL)isRegistered;
- (void)authManagerDidRegister:(LWAuthManager *)manager;
- (void)authManagerDidAuthenticate:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status;
- (void)authManagerDidSendDocument:(LWAuthManager *)manager ofType:(KYCDocumentType)docType;
- (void)authManager:(LWAuthManager *)manager didGetKYCStatus:(NSString *)status;
- (void)authManagerDidSetKYCStatus:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didValidatePin:(BOOL)isValid;
- (void)authManagerDidSetPin:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didReceiveRestrictedCountries:(NSArray *)countries;

@end


@interface LWAuthManager : LWNetAccessor {
    
}

SINGLETON_DECLARE

@property (weak, nonatomic) id<LWAuthManagerDelegate> delegate;

@property (readonly, nonatomic) BOOL     isAuthorized;
@property (readonly, nonatomic) NSString *authCookie;

@property (copy, nonatomic) UIImage *imageSelfie;
@property (copy, nonatomic) UIImage *imageIdCard;
@property (copy, nonatomic) UIImage *imageProofOfAddress;


#pragma mark - Common

- (void)requestEmailValidation:(NSString *)email;
- (void)requestAuthentication:(LWAuthenticationData *)data;
- (void)requestRegistration:(LWRegistrationData *)data;
- (void)requestDocumentsToUpload;
- (void)requestSendDocument:(KYCDocumentType)docType image:(UIImage *)image;
- (void)requestKYCStatusGet;
- (void)requestKYCStatusSet;
- (void)requestPinSecurityGet:(NSString *)pin;
- (void)requestPinSecuritySet:(NSString *)pin;
- (void)requestRestrictedCountries;

@end
