//
//  LWCache.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"


@interface LWCache : NSObject {
    
}

SINGLETON_DECLARE


#pragma mark - Properties

@property (copy, nonatomic) NSNumber *refreshTimer;
@property (copy, nonatomic) NSString *baseAssetId;
@property (copy, nonatomic) NSString *baseAssetSymbol;
@property (copy, nonatomic) NSArray  *baseAssets; // Array of LWAssetModel items
@property (assign, nonatomic) BOOL shouldSignOrder;

@end
