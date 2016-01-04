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
#import "LWAuthSteps.h"

@class LWAuthManager;
@class LWLykkeWalletsData;
@class LWBankCardsAdd;
@class LWAssetModel;
@class LWAssetPairRateModel;
@class LWAppSettingsModel;


@protocol LWAuthManagerDelegate<NSObject>
@optional
- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context;
- (void)authManager:(LWAuthManager *)manager didCheckRegistration:(BOOL)isRegistered email:(NSString *)email;
- (void)authManagerDidRegister:(LWAuthManager *)manager;
- (void)authManagerDidRegisterGet:(LWAuthManager *)manager KYCStatus:(NSString *)status isPinEntered:(BOOL)isPinEntered;
- (void)authManagerDidAuthenticate:(LWAuthManager *)manager KYCStatus:(NSString *)status isPinEntered:(BOOL)isPinEntered;
- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status;
- (void)authManagerDidSendDocument:(LWAuthManager *)manager ofType:(KYCDocumentType)docType;
- (void)authManager:(LWAuthManager *)manager didGetKYCStatus:(NSString *)status;
- (void)authManagerDidSetKYCStatus:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didValidatePin:(BOOL)isValid;
- (void)authManagerDidSetPin:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didReceiveRestrictedCountries:(NSArray *)countries;
- (void)authManager:(LWAuthManager *)manager didReceivePersonalFullName:(NSString *)fullName phone:(NSString *)phone email:(NSString *)email;
- (void)authManager:(LWAuthManager *)manager didReceiveLykkeData:(LWLykkeWalletsData *)data;
- (void)authManagerDidNotAuthorized:(LWAuthManager *)manager;
- (void)authManagerDidCardAdd:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didGetBaseAssets:(NSArray *)assets;
- (void)authManager:(LWAuthManager *)manager didGetBaseAsset:(LWAssetModel *)asset;
- (void)authManagerDidSetAsset:(LWAuthManager *)manager;
- (void)authManager:(LWAuthManager *)manager didGetAssetPairs:(NSArray *)assetPairs;
- (void)authManager:(LWAuthManager *)manager didGetAssetPairRate:(LWAssetPairRateModel *)assetPairRate;
- (void)authManager:(LWAuthManager *)manager didGetAssetPairRates:(NSArray *)assetPairRates;
- (void)authManager:(LWAuthManager *)manager didGetAppSettings:(LWAppSettingsModel *)appSettings;

@end


@interface LWAuthManager : LWNetAccessor {
    
}

SINGLETON_DECLARE

@property (weak, nonatomic) id<LWAuthManagerDelegate> delegate;

@property (readonly, nonatomic) BOOL               isAuthorized;
@property (readonly, nonatomic) LWRegistrationData *registrationData;
@property (readonly, nonatomic) LWDocumentsStatus  *documentsStatus;


#pragma mark - Common

- (void)requestEmailValidation:(NSString *)email;
- (void)requestAuthentication:(LWAuthenticationData *)data;
- (void)requestRegistration:(LWRegistrationData *)data;
- (void)requestRegistrationGet;
- (void)requestDocumentsToUpload;
- (void)requestSendDocument:(KYCDocumentType)docType image:(UIImage *)image;
- (void)requestSendDocumentBin:(KYCDocumentType)docType image:(UIImage *)image;
- (void)requestKYCStatusGet;
- (void)requestKYCStatusSet;
- (void)requestPinSecurityGet:(NSString *)pin;
- (void)requestPinSecuritySet:(NSString *)pin;
- (void)requestRestrictedCountries;
- (void)requestPersonalData;
- (void)requestLykkeWallets;
- (void)requestSendLog:(NSString *)log;
- (void)requestAddBankCard:(LWBankCardsAdd *)card;
- (void)requestBaseAssets;
- (void)requestBaseAssetGet;
- (void)requestBaseAssetSet:(NSString *)assetId;
- (void)requestAssetPairs;
- (void)requestAssetPairRate:(NSString *)pairId;
- (void)requestAssetPairRates;
- (void)requestAppSettings;


#pragma mark - Static methods

+ (BOOL)isAuthneticationFailed:(NSURLResponse *)response;

@end
