//
//  LWHistoryPresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthComplexPresenter.h"


@interface LWHistoryPresenter : LWAuthComplexPresenter {
    
}


#pragma mark - Properties

@property (copy,   nonatomic) NSString *assetId;
@property (assign, nonatomic) BOOL shouldGoBack;

@end
