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
#import "LWPacketBlockchainCashTransaction.h"
#import "LWPacketBlockchainExchangeTransaction.h"
#import "LWPacketBlockchainTransferTransaction.h"
#import "LWPacketTransactions.h"
#import "LWPacketMarketOrder.h"
#import "LWPacketSendBlockchainEmail.h"
#import "LWPacketExchangeInfoGet.h"
#import "LWPacketDicts.h"
#import "LWPacketCashOut.h"
#import "LWPacketTransfer.h"
#import "LWPacketEmailVerificationGet.h"
#import "LWPacketEmailVerificationSet.h"
#import "LWPacketPhoneVerificationGet.h"
#import "LWPacketPhoneVerificationSet.h"
#import "LWPacketClientFullNameSet.h"
#import "LWPacketCountryCodes.h"
#import "LWPacketGraphPeriodsGet.h"
#import "LWPacketGraphRates.h"

#import "LWLykkeWalletsData.h"
#import "LWBankCardsAdd.h"
#import "LWPacketWallets.h"
#import "LWKeychainManager.h"
#import "LWAssetDealModel.h"
#import "LWPersonalDataModel.h"
#import "LWAssetBlockchainModel.h"
#import "LWExchangeInfoModel.h"


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
    LWPacketWallets *pack = [LWPacketWallets new];
    
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

- (void)requestBlockchainOrderTransaction:(NSString *)orderId {
    LWPacketBlockchainTransaction *pack = [LWPacketBlockchainTransaction new];
    pack.orderId = orderId;
    
    [self sendPacket:pack];
}

- (void)requestBlockchainCashTransaction:(NSString *)cashOperationId {
    LWPacketBlockchainCashTransaction *pack = [LWPacketBlockchainCashTransaction new];
    pack.cashOperationId = cashOperationId;
    
    [self sendPacket:pack];
}

- (void)requestBlockchainExchangeTransaction:(NSString *)exchnageOperationId {
    LWPacketBlockchainExchangeTransaction *pack = [LWPacketBlockchainExchangeTransaction new];
    pack.exchangeOperationId = exchnageOperationId;
    
    [self sendPacket:pack];
}

- (void)requestBlockchainTransferTrnasaction:(NSString *)transferOperationId {
    LWPacketBlockchainTransferTransaction *pack = [LWPacketBlockchainTransferTransaction new];
    pack.transferOperationId = transferOperationId;
    
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

- (void)requestExchangeInfo:(NSString *)exchangeId {
    LWPacketExchangeInfoGet *pack = [LWPacketExchangeInfoGet new];
    pack.exchangeId = exchangeId;
    
    [self sendPacket:pack];
}

- (void)requestDictionaries {
    LWPacketDicts *pack = [LWPacketDicts new];
    
    [self sendPacket:pack];
}

- (void)requestCashOut:(NSNumber *)amount assetId:(NSString *)assetId multiSig:(NSString *)multiSig {
    LWPacketCashOut *pack = [LWPacketCashOut new];
    pack.multiSig = multiSig;
    pack.amount = amount;
    pack.assetId = assetId;
    
    [self sendPacket:pack];
}

- (void)requestTransfer:(NSString *)assetId amount:(NSNumber *)amount recipient:(NSString *)recepientId {
    LWPacketTransfer *pack = [LWPacketTransfer new];
    pack.assetId = assetId;
    pack.amount = amount;
    pack.recepientId = recepientId;
    
    [self sendPacket:pack];
}

- (void)requestVerificationEmail:(NSString *)email {
    LWPacketEmailVerificationSet *pack = [LWPacketEmailVerificationSet new];
    pack.email = email;
    
    [self sendPacket:pack];
}

- (void)requestVerificationEmail:(NSString *)email forCode:(NSString *)code {
    LWPacketEmailVerificationGet *pack = [LWPacketEmailVerificationGet new];
    pack.email = email;
    pack.code = code;
    
    [self sendPacket:pack];
}

- (void)requestVerificationPhone:(NSString *)phone {
    LWPacketPhoneVerificationSet *pack = [LWPacketPhoneVerificationSet new];
    pack.phone = phone;
    
    [self sendPacket:pack];
}

- (void)requestVerificationPhone:(NSString *)phone forCode:(NSString *)code {
    LWPacketPhoneVerificationGet *pack = [LWPacketPhoneVerificationGet new];
    pack.phone = phone;
    pack.code = code;
    
    [self sendPacket:pack];
}

- (void)requestSetFullName:(NSString *)fullName {
    LWPacketClientFullNameSet *pack = [LWPacketClientFullNameSet new];
    pack.fullName = fullName;
    
    [self sendPacket:pack];
}

- (void)requestCountyCodes {
    LWPacketCountryCodes *pack = [LWPacketCountryCodes new];
    
    [self sendPacket:pack];
}

- (void)requestGraphPeriods {
    LWPacketGraphPeriodsGet *pack = [LWPacketGraphPeriodsGet new];
    
    [self sendPacket:pack];
}

- (void)requestGraphPeriodRates:(NSString *)period assetId:(NSString *)assetId points:(NSNumber *)points {
    LWPacketGraphRates *pack = [LWPacketGraphRates new];
    pack.period  = [period copy];
    pack.assetId = [assetId copy];
    pack.points  = [points copy];
    
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
        if ([self.delegate respondsToSelector:@selector(authManagerDidRegisterGet:KYCStatus:isPinEntered:personalData:)]) {
            LWPacketRegistrationGet *packet = (LWPacketRegistrationGet *)pack;
            [self.delegate authManagerDidRegisterGet:self
                                           KYCStatus:packet.status
                                        isPinEntered:packet.isPinEntered
                                        personalData:packet.personalData];
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
        if ([self.delegate respondsToSelector:@selector(authManager:didGetKYCStatus: personalData:)]) {
            LWPacketKYCStatusGet *packet = (LWPacketKYCStatusGet *)pack;
            [self.delegate authManager:self
                       didGetKYCStatus:packet.status
                          personalData:packet.personalData];
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
    else if (pack.class == LWPacketWallets.class) {
        // recieved data with all wallets
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveLykkeData:)]) {
            [self.delegate authManager:self didReceiveLykkeData:((LWPacketWallets *)pack).data];
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
    else if (pack.class == LWPacketBlockchainCashTransaction.class) {
        if ([self.delegate respondsToSelector:@selector(authManager: didGetBlockchainCashTransaction:)]) {
            [self.delegate authManager:self didGetBlockchainCashTransaction:((LWPacketBlockchainCashTransaction *)pack).blockchain];
        }
    }
    else if (pack.class == LWPacketBlockchainExchangeTransaction.class) {
        if ([self.delegate respondsToSelector:@selector(authManager: didGetBlockchainExchangeTransaction:)]) {
            [self.delegate authManager:self didGetBlockchainExchangeTransaction:((LWPacketBlockchainExchangeTransaction *)pack).blockchain];
        }
    }
    else if (pack.class == LWPacketBlockchainTransferTransaction.class) {
        if ([self.delegate respondsToSelector:@selector(authManager: didGetBlockchainTransferTransaction:)]) {
            [self.delegate authManager:self didGetBlockchainTransferTransaction:((LWPacketBlockchainTransferTransaction *)pack).blockchain];
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
    else if (pack.class == LWPacketExchangeInfoGet.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didReceiveExchangeInfo:)]) {
            [self.delegate authManager:self didReceiveExchangeInfo:((LWPacketExchangeInfoGet *)pack).model];
        }
    }
    else if (pack.class == LWPacketDicts.class) {
        if ([self.delegate respondsToSelector:@selector(authManager: didReceiveAssetDicts:)]) {
            [self.delegate authManager:self didReceiveAssetDicts:((LWPacketDicts *)pack).assetsDictionary];
        }
    }
    else if (pack.class == LWPacketCashOut.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidCashOut:)]) {
            [self.delegate authManagerDidCashOut:self];
        }
    }
    else if (pack.class == LWPacketTransfer.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidTransfer:)]) {
            [self.delegate authManagerDidTransfer:self];
        }
    }
    else if (pack.class == LWPacketEmailVerificationGet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidCheckValidationEmail:passed:)]) {
            [self.delegate authManagerDidCheckValidationEmail:self passed:((LWPacketEmailVerificationGet *)pack).isPassed];
        }
    }
    else if (pack.class == LWPacketEmailVerificationSet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSendValidationEmail:)]) {
            [self.delegate authManagerDidSendValidationEmail:self];
        }
    }
    else if (pack.class == LWPacketPhoneVerificationGet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidCheckValidationPhone:passed:)]) {
            [self.delegate authManagerDidCheckValidationPhone:self passed:((LWPacketPhoneVerificationGet *)pack).isPassed];
        }
    }
    else if (pack.class == LWPacketPhoneVerificationSet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSendValidationPhone:)]) {
            [self.delegate authManagerDidSendValidationPhone:self];
        }
    }
    else if (pack.class == LWPacketClientFullNameSet.class) {
        if ([self.delegate respondsToSelector:@selector(authManagerDidSetFullName:)]) {
            [self.delegate authManagerDidSetFullName:self];
        }
    }
    else if (pack.class == LWPacketCountryCodes.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didGetCountryCodes:)]) {
            [self.delegate authManager:self didGetCountryCodes:((LWPacketCountryCodes *)pack).countries];
        }
    }
    else if (pack.class == LWPacketGraphPeriodsGet.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didGetGraphPeriods:)]) {
            [self.delegate authManager:self didGetGraphPeriods:((LWPacketGraphPeriodsGet *)pack).graphPeriods];
        }
    }
    else if (pack.class == LWPacketGraphRates.class) {
        if ([self.delegate respondsToSelector:@selector(authManager:didGetGraphPeriodRates:)]) {
            [self.delegate authManager:self didGetGraphPeriodRates:((LWPacketGraphRates *)pack).data];
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

+ (BOOL)isNotOk:(NSURLResponse *)response {
    NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse*)response;
    if (urlResponse && urlResponse.statusCode >= 400) {
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
