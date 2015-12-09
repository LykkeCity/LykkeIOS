//
//  LWAuthManager.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"


@interface LWAuthManager : NSObject {
    
}

SINGLETON_DECLARE

@property (readonly, nonatomic) BOOL isAuthorized;

@end
