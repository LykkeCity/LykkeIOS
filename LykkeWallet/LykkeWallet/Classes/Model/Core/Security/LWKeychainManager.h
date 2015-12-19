//
//  LWKeychainManager.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWKeychainManager : NSObject {
    
}

#pragma mark - Common

+ (void)saveLogin:(NSString *)login andToken:(NSString *)token;
+ (NSString *)readLogin;
+ (NSString *)readToken;

@end
