//
//  LWCache.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWCache.h"


@implementation LWCache


#pragma mark - Root

SINGLETON_INIT {
    self = [super init];
    if (self) {
        _refreshTimer = [NSNumber numberWithInteger:15];
    }
    return self;
}

@end
