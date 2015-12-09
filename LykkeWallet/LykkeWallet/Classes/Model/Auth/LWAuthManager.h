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

NFDECLARE(AuthManagerDidCheckEmail);
NFDECLARE(AuthManagerDidFail);
NFDECLAREKEY(AuthManagerError);
NFDECLAREKEY(AuthManagerEmail);


@interface LWAuthManager : NSObject {
    
}

SINGLETON_DECLARE

@property (readonly, nonatomic) BOOL isAuthorized;


#pragma mark - Common

- (void)requestEmailValidation:(NSString *)email;

@end
