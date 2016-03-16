//
//  LWAuthManager.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthManager.h"
#import "LWPacketAccountExist.h"
#import "LWPacketAuthentication.h"
#import "LWPacketRegistration.h"
#import "LWPacketRegistrationGet.h"
#import "LWPacketCheckDocumentsToUpload.h"
#import "LWPacketKYCSendDocument.h"
#import "LWPacketKYCSendDocumentBin.h"
#import "LWPacketKYCStatusGet.h"
#import "LWPacketKYCStatusSet.h"
#import "LWPacketPinSecurityGet.h"
#import "LWPacketPinSecuritySet.h"
#import "LWPacketRestrictedCountries.h"
#import "LWPacketPersonalData.h"
#import "LWPacketLog.h"
#import "LWPacketBankCards.h"
#import "LWPacketBaseAssets.h"
#import "LWPacketBaseAssetGet.h"
#import "LWPacketBaseAssetSet.h"
#import "LWPacketAssetPair.h"
#import "LWPacketAssetPairs.h"
#import "LWPacketAssetPairRate.h"
#import "LWPacketAssetPairRates.h"
#import "LWPacketAppSettings.h"
#import "LWPacketAssetDescription.h"
#import "LWPacketBuySellAsset.h"
#import "LWPacketSettingSignOrder.h"
#import "LWPacketBlockchainTransaction.h"
#import "LWPacketTransactions.h"
#import "LWPacketMarketOrder.h"
#import "LWPacketSendBlockchainEmail.h"

#import "LWLykkeWalletsData.h"
#import "LWBankCardsAdd.h"
#import "LWPacketLykkeWallet.h"
#import "LWKeychainManager.h"
#import "LWAssetDealModel.h"
#import "LWPersonalDataModel.h"
#import "LWAssetBlockchainModel.h"


@interface LWAuthManager () {
    
}

#pragma mark - Observing

- (void)observeGDXNetAdapterDidReceiveResponseNotification:(NSNotification *)notification;
- (void)observeGDXNetAdapterDidFailRequestNotification:(NSNotification *)notification;

@end


@implementation LWAuthManager


#pragma mark - Root

SINGLETON_INIT {
    self = [super init];
    if (self) {
        [self subscribe:kNotificationGDXNetAdapterDidReceiveResponse
               selector:@selector(observeGDXNetAdapterDidReceiveResponseNotification:)];
        [self subscribe:kNotificationGDXNetAdapterDidFailRequest
               selector:@selector(observeGDXNetAdapterDidFailRequestNotification:)];
    }
    return self;
}


#pragma mark - Common

- (void)requestEmailValidation:(NSString *)email {
    LWPacketAccountExist *pack = [LWPacketAccountExist new];
    pack.email = email;
    
    [self sendPacket:pack];
}

- (void)requestAuthentication:(LWAuthenticationData *)data {
    LWPacketAuthentication *pack = [LWPacketAuthentication new];
    pack.authenticationData = data;
    
    [self sendPacket:pack];
}

- (void)requestRegistration:(LWRegistrationData *)data {
    LWPacketRegistration *pack = [LWPacketRegistration new];
    pack.registrationData = data;
    
    [self sendPacket:pack];
}

- (void)requestRegistrationGet {
    LWPacketRegistrationGet *pack = [LWPacketRegistrationGet new];
    
    [self sendPacket:pack];
}

- (void)requestDocumentsToUpload {
    LWPacketCheckDocumentsToUpload *pack = [LWPacketCheckDocumentsToUpload new];

    [self sendPacket:pack];
}

- (void)requestSendDocument:(KYCDocumentType)docType image:(UIImage *)image {
    LWPacketKYCSendDocument *pack = [LWPacketKYCSendDocument new];
    pack.docType = docType;
    
    // set document compression
    double const compression = [[LWAuthManager instance].documentsStatus compression:docType];
    pack.imageJPEGRepresentation = UIImageJPEGRepresentation(image, compression);
    
    [self sendPacket:pack];
}

- (void)requestSendDocumentBin:(KYCDocumentType)docType image:(UIImage *)image {
    LWPacketKYCSendDocumentBin *pack = [LWPacketKYCSendDocumentBin new];
    pack.docType = docType;

    // set document compression
    double const compression = [[LWAuthManager instance].documentsStatus compression:docType];
    pack.imageJPEGRepresentation = UIImageJPEGRepresentation(image, compression);
    
    [self sendPacket:pack];
}

- (void)requestKYCStatusGet {
    LWPacketKYCStatusGet *pack = [LWPacketKYCStatusGet new];
    
    [self sendPacket:pack];
}

- (void)requestKYCStatusSet {
    LWPacketKYCStatusSet *pack = [LWPacketKYCStatusSet new];
    
    [self sendPacket:pack];
}

- (void)requestPinSecurityGet:(NSString *)pin {
    LWPacketPinSecurityGet *pack = [LWPacketPinSecurityGet new];
    pack.pin = pin;
    
    [self sendPacket:pack];
}

- (void)requestPinSecuritySet:(NSString *)pin {
    LWPacketPinSecuritySet *pack = [LWPacketPinSecuritySet new];
    pack.pin = pin;
    
    [self sendPacket:pack];
}

- (void)requestRestrictedCountries {
    LWPacketRestrictedCountries *pack = [LWPacketRestrictedCountries new];
    
    [self sendPacket:pack];
}

- (void)requestPersonalData {
    LWPacketPersonalData *pack = [LWPacketPersonalData new];
    
    [self sendPacket:pack];
}

- (void)requestLykkeWallets {
    LWPacketLykkeWallet *pack = [LWPacketLykkeWallet new];
    
    [self sendPacket:pack];
}

- (void)requestSendLog:(NSString *)log {
    LWPacketLog *pack = [LWPacketLog new];
    pack.log = log;
    
    [self sendPacket:pack];
}

- (void)requestAddBankCard:(LWBankCardsAdd *)card {
    LWPacketBankCards *pack = [LWPacketBankCards new];
    pack.addCardData = card;
    
    [self sendPacket:pack];
}

- (void)requestBaseAssets {
    LWPacketBaseAssets *pack = [LWPacketBaseAssets new];
    
    [self sendPacket:pack];
}

- (void)requestBaseAssetGet {
    LWPacketBaseAssetGet *pack = [LWPacketBaseAssetGet new];
    
    [self sendPacket:pack];
}

- (void)requestBaseAssetSet:(NSString *)assetId {
    LWPacketBaseAssetSet *pack = [LWPacketBaseAssetSet new];
    pack.identity = assetId;
    
    [self sendPacket:pack];
}

- (void)requestAssetPair:(NSString *)pairId {
    LWPacketAssetPair *pack = [LWPacketAssetPair new];
    pack.identity = pairId;
    
    [self sendPacket:pack];
}

- (void)requestAssetPairs {
    LWPacketAssetPairs *pack = [LWPacketAssetPairs new];
    
    [self sendPacket:pack];
}

- (void)requestAssetPairRate:(NSString *)pairId {
    LWPacketAssetPairRate *pack = [LWPacketAssetPairRate new];
    pack.identity = pairId;
    
    [self sendPacket:pack];
}

- (void)requestAssetPairRates {
    LWPacketAssetPairRates *pack = [LWPacketAssetPairRates new];
    
    [self sendPacket:pack];
}

- (void)requestAssetDescription:(NSString *)assetId {
    LWPacketAssetDescription *pack = [LWPacketAssetDescription new];
    pack.identity = assetId;
    
    [self sendPacket:pack];
}

- (void)requestAppSettings {
    LWPacketAppSettings *pack = [LWPacketAppSettings new];
    
    [self sendPacket:pack];
}

- (void)requestPurchaseAsset:(NSString *)asset assetPair:(NSString *)assetPair volume:(NSNumber *)volume rate:(NSNumber *)rate {
    LWPacketBuySellAsset *pack = [LWPacketBuySellAsset new];
    pack.baseAsset = asset;
    pack.assetPair = assetPair;
    pack.volume    = volume;
    pack.rate      = rate;
    
    [self sendPacket:pack];
}

- (void)requestSellAsset:(NSString *)asset assetPair:(NSString *)assetPair volume:(NSNumber *)volume rate:(NSNumber *)rate {
    LWPacketBuySellAsset *pack = [LWPacketBuySellAsset new];
    pack.baseAsset = asset;
    pack.assetPair = assetPair;
    pack.volume    = volume;
    pack.rate      = rate;
    
    [self sendPacket:pack];
}

- (void)requestSignOrders:(BOOL)shouldSignOrders {
    LWPacketSettingSignOrder *pack = [LWPacketSettingSignOrder new];
    pack.shouldSignOrder = shouldSignOrders;
    
    [self sendPacket:pack];
}

- (void)requestBlockchainTransaction:(NSString *)orderId {
    LWPacketBlockchainTransaction *pack = [LWPacketBlockchainTransaction new];
    pack.orderId = orderId;
    
    [self sendPacket:pack];
}

- (void)requestTransactions:(NSString *)assetId {
    LWPacketTransactions *pack = [LWPacketTransactions new];
    pack.assetId = assetId;
    
    [self sendPacket:pack];
}

- (void)requestMarketOrder:(NSString *)orderId {
    LWPacketMarketOrder *pack = [LWPacketMarketOrder new];
    pack.orderId = orderId;
    
    [self sendPacket:pack];
}

- (void)requestEmailBlockchain {
    LWPacketSendBlockchainEmail *pack = [LWPacketSendBlockchainEmail new];
    
    [self sendPacket:pack];
}


#pragma mark - Observing

- (void)observeGDXNetAdapterDidReceiveResponseNotification:(NSNotification *)notification {
    GDXRESTContext *ctx = notification.userInfo[kNotificationKeyGDXNetContext];
    LWPacket *pack = (LWPacket *)ctx.packet;
    // decline rejected packet
    if (pack.isRejected) {
        [self observeGDXNetAdapterDidFailRequestNotification:notification];
        // return immediately
        return;
    }

    // parse packet by class
    if (pack.class == LWPacketAccountExist.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didCheckRegistration:email:)])  {
            LWPacketAccountExist *account = (LWPacketAccountExist *)pack;
            [self.delegate authManager:self
                  didCheckRegistration:account.isRegistered
                                 email:account.email];
        }
    }
    else if (pack.class == LWPacketAuthentication.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidAuthenticate:KYCStatus:isPinEntered:)]) {
            LWPacketAuthentication *auth = (LWPacketAuthentication *)pack;
            [self.delegate authManagerDidAuthenticate:self
                                            KYCStatus:auth.status
                                         isPinEntered:auth.isPinEntered];
        }
    }
    else if (pack.class == LWPacketRegistration.class) {
        // set self registration data
        _registrationData = ((LWPacketRegistration *)pack).registrationData;
        // call delegate
        if ([self.delegate respondsToSelector:@selector(authManagerDidRegister:)]) {
            [self.delegate authManagerDidRegister:self];
        }
    }
    else if (pack.class == LWPacketRegistrationGet.class) {
        // call delegate
        if ([self.delegate respondsToSelector:@selector(authManagerDidRegisterGet:KYCStatus:isPinEntered:)]) {
            LWPacketRegistrationGet *registration = (LWPacketRegistrationGet *)pack;
            [self.delegate authManagerDidRegisterGet:self
                                           KYCStatus:registration.status
                                        isPinEntered:registration.isPinEntered];
        }
    }
    else if (pack.class == LWPacketPersonalData.class) {
        // call delegate
        if ([self.delegate respondsToSelector:@selector(authManager:didReceivePersonalData:)]) {
            [self.delegate authManager:self didReceivePersonalData:((LWPacketPersonalData *)pack).data];
        }
    }
    else if (pack.class == LWPacketCheckDocumentsToUpload.class) {
        // set self documents status
        _documentsStatus = ((LWPacketCheckDocumentsToUpload *)pack).documentsStatus;
        // call delegate
        if ([self.delegate respondsToSelector:@selector(authManager:didCheckDocumentsStatus:)]) {
            [self.delegate authManager:self didCheckDocumentsStatus:self.documentsStatus];
        }
    }
    else if (pack.class == LWPacketKYCSendDocument.class ||
             pack.class == LWPacketKYCSendDocumentBin.class) {
        KYCDocumentType docType = ((LWPacketKYCSendDocument *)pack).docType;
        // modify self documents status
        [self.documentsStatus setTypeUploaded:docType withImage:nil];
        [self.documentsStatus setCroppedStatus:docType withCropped:NO];
        // call delegate
        if ([self.delegate respondsToSelector:@selector(authManagerDidSendDocument:ofType:)]) {
            [self.delegate authManagerDidSendDocument:self ofType:docType];
        }
    }
    else if (pack.class == LWPacketKYCStatusGet.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didGetKYCStatus:)]) {
            [self.delegate authManager:self didGetKYCStatus:((LWPacketKYCStatusGet *)pack).status];
        }
    }
    else if (pack.class == LWPacketKYCStatusSet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSetKYCStatus:)]) {
            [self.delegate authManagerDidSetKYCStatus:self];
        }
    }
    else if (pack.class == LWPacketPinSecurityGet.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didValidatePin:)]) {
            [self.delegate authManager:self didValidatePin:((LWPacketPinSecurityGet *)pack).isPassed];
        }
    }
    else if (pack.class == LWPacketPinSecuritySet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSetPin:)]) {
            [self.delegate authManagerDidSetPin:self];
        }
    }
    else if (pack.class == LWPacketRestrictedCountries.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveRestrictedCountries:)]) {
            [self.delegate authManager:self
         didReceiveRestrictedCountries:((LWPacketRestrictedCountries *)pack).countries];
        }
    }
    else if (pack.class == LWPacketLykkeWallet.class) {
        // recieved data with all wallets
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveLykkeData:)]) {
            [self.delegate authManager:self didReceiveLykkeData:((LWPacketLykkeWallet *)pack).data];
        }
    }
    else if (pack.class == LWPacketLog.class) {
        // nothing to do
    }
    else if (pack.class == LWPacketBankCards.class) {
        // receiving confirmation about added credit card
        if ([self.delegate respondsToSelector:@selector(authManagerDidCardAdd:)]) {
            [self.delegate authManagerDidCardAdd:self];
        }
    }
    else if (pack.class == LWPacketBaseAssets.class) {
        // receiving assets catalog
        if ([self.delegate respondsToSelector:@selector(authManager:didGetBaseAssets:)]) {
            [self.delegate authManager:self didGetBaseAssets:((LWPacketBaseAssets *)pack).assets];
        }
    }
    else if (pack.class == LWPacketBaseAssetGet.class) {
        // receving base asset
        if ([self.delegate respondsToSelector:@selector(authManager: didGetBaseAsset:)]) {
            [self.delegate authManager:self didGetBaseAsset:((LWPacketBaseAssetGet *)pack).asset];
        }
    }
    else if (pack.class == LWPacketBaseAssetSet.class) {
        // receiving base asset set confirmation
        if ([self.delegate respondsToSelector:@selector(authManagerDidSetAsset:)]) {
            [self.delegate authManagerDidSetAsset:self];
        }
    }
    else if (pack.class == LWPacketAssetPair.class) {
        // receiving asset pair by id
        if ([self.delegate respondsToSelector:@selector(authManager:didGetAssetPair:)]) {
            [self.delegate authManager:self didGetAssetPair:((LWPacketAssetPair *)pack).assetPair];
        }
    }
    else if (pack.class == LWPacketAssetPairs.class) {
        // receiving asset pairs
        if ([self.delegate respondsToSelector:@selector(authManager:didGetAssetPairs:)]) {
            [self.delegate authManager:self didGetAssetPairs:((LWPacketAssetPairs *)pack).assetPairs];
        }
    }
    else if (pack.class == LWPacketAssetPairRate.class) {
        // receiving asset pair rate by id
        if ([self.delegate respondsToSelector:@selector(authManager:didGetAssetPairRate:)]) {
            [self.delegate authManager:self didGetAssetPairRate:((LWPacketAssetPairRate *)pack).assetPairRate];
        }
    }
    else if (pack.class == LWPacketAssetPairRates.class) {
        // receiving asset pair rates
        if ([self.delegate respondsToSelector:@selector(authManager:didGetAssetPairRates:)]) {
            [self.delegate authManager:self didGetAssetPairRates:((LWPacketAssetPairRates *)pack).assetPairRates];
        }
    }
    else if (pack.class == LWPacketAssetDescription.class) {
        // receiving asset description
        if ([self.delegate respondsToSelector:@selector(authManager:didGetAssetDescription:)]) {
            [self.delegate authManager:self didGetAssetDescription:((LWPacketAssetDescription *)pack).assetDescription];
        }
    }
    else if (pack.class == LWPacketAppSettings.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didGetAppSettings:)]) {
            [self.delegate authManager:self didGetAppSettings:((LWPacketAppSettings *)pack).appSettings];
        }
    }
    else if (pack.class == LWPacketBuySellAsset.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveDealResponse:)]) {
            [self.delegate authManager:self didReceiveDealResponse:((LWPacketBuySellAsset *)pack).deal];
        }
    }
    else if (pack.class == LWPacketSettingSignOrder.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSetSignOrders:)]) {
            [self.delegate authManagerDidSetSignOrders:self];
        }
    }
    else if (pack.class == LWPacketBlockchainTransaction.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didGetBlockchainTransaction:)]) {
            [self.delegate authManager:self didGetBlockchainTransaction:((LWPacketBlockchainTransaction *)pack).blockchain];
        }
    }
    else if (pack.class == LWPacketTransactions.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveTransactions:)]) {
            [self.delegate authManager:self didReceiveTransactions:((LWPacketTransactions *)pack).model];
        }
    }
    else if (pack.class == LWPacketMarketOrder.class) {
        // receiving market order info
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveMarketOrder:)]) {
            [self.delegate authManager:self didReceiveMarketOrder:((LWPacketMarketOrder *)pack).model];
        }
    }
    else if (pack.class == LWPacketSendBlockchainEmail.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSendBlockchainEmail:)]) {
            [self.delegate authManagerDidSendBlockchainEmail:self];
        }
    }
}

- (void)observeGDXNetAdapterDidFailRequestNotification:(NSNotification *)notification {
    GDXRESTContext *ctx = notification.userInfo[kNotificationKeyGDXNetContext];
    LWPacket *pack = (LWPacket *)ctx.packet;
    
    // check if user not authorized - kick them
    if ([LWAuthManager isAuthneticationFailed:ctx.task.response]) {
        [self.delegate authManagerDidNotAuthorized:self];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(authManager:didFailWithReject:context:)]) {
            [self.delegate authManager:self
                     didFailWithReject:pack.reject
                               context:ctx];
        }
    }
}


#pragma mark - Properties

- (BOOL)isAuthorized {
    return ([LWKeychainManager instance].token != nil);
}


#pragma mark - Static methods

+ (BOOL)isAuthneticationFailed:(NSURLResponse *)response {
    NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse*)response;
    NSInteger const NotAuthenticated = 401;
    if (urlResponse && urlResponse.statusCode == NotAuthenticated) {
        return YES;
    }
    return NO;
}

+ (BOOL)isInternalServerError:(NSURLResponse *)response {
    NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse*)response;
    NSInteger const InternalServerError = 500;
    if (urlResponse && urlResponse.statusCode == InternalServerError) {
        return YES;
    }
    return NO;
}

@end
