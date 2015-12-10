//
//  LWAuthManager.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthManager.h"
#import "LWPacketAccountExist.h"


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
    
    [[GDXNet instance] send:pack userInfo:nil method:GDXNetSendMethodREST];
}


#pragma mark - Observing

- (void)observeGDXNetAdapterDidReceiveResponseNotification:(NSNotification *)notification {
    GDXNetContext *ctx = notification.userInfo[kNotificationKeyGDXNetContext];
    LWPacketAccountExist *pack = (LWPacketAccountExist *)ctx.packet;
    
    if ([self.delegate respondsToSelector:@selector(authManager:didCheckEmail:)])  {
        [self.delegate authManager:self didCheckEmail:pack.isRegistered];
    }
}

- (void)observeGDXNetAdapterDidFailRequestNotification:(NSNotification *)notification {
    GDXRESTContext *ctx = notification.userInfo[kNotificationKeyGDXNetContext];
    LWPacket *pack = (LWPacket *)ctx.packet;
    
    if ([self.delegate respondsToSelector:@selector(authManager:didFail:)])  {
        [self.delegate authManager:self didFail:pack.reject];
    }
}

@end
