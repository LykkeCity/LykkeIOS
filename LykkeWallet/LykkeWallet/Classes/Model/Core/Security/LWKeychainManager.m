//
//  LWKeychainManager.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKeychainManager.h"
#import <Valet/Valet.h>

static NSString *const kKeychainManagerAppId = @"LykkeWallet";
static NSString *const kKeychainManagerToken = @"Token";
static NSString *const kKeychainManagerLogin = @"Login";


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

- (void)clear {
    [valet removeObjectForKey:kKeychainManagerToken];
    [valet removeObjectForKey:kKeychainManagerLogin];
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

@end
