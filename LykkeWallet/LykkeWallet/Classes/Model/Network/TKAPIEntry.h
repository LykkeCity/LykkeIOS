//
//  TKAPIEntry.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"
#import "NSObject+GDXObserver.h"

NFDECLARE(APIEntryDidReceiveResponse);
NFDECLARE(APIEntryDidFail);
NFDECLAREKEY(APIEntryError);


@interface TKAPIEntry : NSObject {
    
}

SINGLETON_DECLARE

@end
