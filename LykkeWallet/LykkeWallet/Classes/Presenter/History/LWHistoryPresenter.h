//
//  LWHistoryPresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthenticatedTablePresenter.h"


@interface LWHistoryPresenter : LWAuthenticatedTablePresenter {
    
}


#pragma mark - Properties

@property (copy,   nonatomic) NSString *assetId;
@property (assign, nonatomic) BOOL shouldGoBack;

@end
