//
//  LWAuthManager.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"
#import "NSObject+GDXObserver.h"

@class LWAuthManager;


@protocol LWAuthManagerDelegate<NSObject>
@optional
- (void)authManager:(LWAuthManager *)manager didCheckEmail:(BOOL)isRegistered;
- (void)authManager:(LWAuthManager *)manager didFail:(NSDictionary *)reject;

@end


@interface LWAuthManager : NSObject {
    
}

SINGLETON_DECLARE

@property (weak, nonatomic) id<LWAuthManagerDelegate> delegate;

@property (readonly, nonatomic) BOOL isAuthorized;


#pragma mark - Common

- (void)requestEmailValidation:(NSString *)email;

@end
