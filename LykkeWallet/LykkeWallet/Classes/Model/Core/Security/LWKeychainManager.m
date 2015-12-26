//
//  LWKeychainManager.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKeychainManager.h"
#import "LWPersonalData.h"
#import <Valet/Valet.h>

static NSString *const kKeychainManagerAppId    = @"LykkeWallet";
static NSString *const kKeychainManagerToken    = @"Token";
static NSString *const kKeychainManagerLogin    = @"Login";
static NSString *const kKeychainManagerPhone    = @"Phone";
static NSString *const kKeychainManagerFullName = @"FullName";


@interface LWKeychainManager () {
    VALValet *valet;
}

@end


@implementation LWKeychainManager


#pragma mark - Root

SINGLETON_INIT {
    self = [super init];
    if (self) {
        valet = [[VALValet alloc] initWithIdentifier:kKeychainManagerAppId
                                       accessibility:VALAccessibilityWhenUnlocked];
    }
    return self;
}


#pragma mark - Common

- (void)saveLogin:(NSString *)login token:(NSString *)token {
    [valet setString:token forKey:kKeychainManagerToken];
    [valet setString:login forKey:kKeychainManagerLogin];
}

- (void)savePersonalData:(LWPersonalData *)personalData {
    if (personalData) {
        if (personalData.phone
            && ![personalData.phone isKindOfClass:[NSNull class]]) {
            [valet setString:personalData.phone    forKey:kKeychainManagerPhone];
        }
        if (personalData.fullName
            && ![personalData.fullName isKindOfClass:[NSNull class]]) {
            [valet setString:personalData.fullName forKey:kKeychainManagerFullName];
        }
    }
}

- (void)clear {
    [valet removeObjectForKey:kKeychainManagerToken];
    [valet removeObjectForKey:kKeychainManagerLogin];
    [valet removeObjectForKey:kKeychainManagerPhone];
    [valet removeObjectForKey:kKeychainManagerFullName];
}


#pragma mark - Properties

- (NSString *)login {
    return [valet stringForKey:kKeychainManagerLogin];
}

- (NSString *)token {
    return [valet stringForKey:kKeychainManagerToken];
}

- (BOOL)isAuthenticated {
    return (self.token && ![self.token isEqualToString:@""]);
}

- (NSString *)fullName {
    return [valet stringForKey:kKeychainManagerFullName];
}

@end
