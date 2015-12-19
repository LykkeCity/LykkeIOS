//
//  LWKeychainManager.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKeychainManager.h"
#import <Valet/Valet.h>


@implementation LWKeychainManager


static NSString *const APP_IDENTIFIER = @"LykkeWallet";
static NSString *const TOKEN_FIELD    = @"Token";
static NSString *const LOGIN_FIELD    = @"Login";


#pragma mark - Common


+ (void)saveLogin:(NSString *)login andToken:(NSString *)token {
    VALValet *valet = [LWKeychainManager valet];
    [valet setString:token forKey:TOKEN_FIELD];
    [valet setString:login forKey:LOGIN_FIELD];
}

+ (NSString *)readLogin {
    VALValet *valet = [LWKeychainManager valet];
    NSString *result = [valet stringForKey:LOGIN_FIELD];
    return result;
}

+ (NSString *)readToken {
    VALValet *valet = [LWKeychainManager valet];
    NSString *result = [valet stringForKey:TOKEN_FIELD];
    return result;
}


#pragma mark - Inetrnal methods


+ (VALValet *)valet {
    VALValet *valet = [[VALValet alloc] initWithIdentifier:APP_IDENTIFIER
                                             accessibility:VALAccessibilityWhenUnlocked];
    return valet;
}

@end
