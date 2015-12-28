//
//  LWAuthStepPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"
#import "LWAuthManager.h"


@interface LWAuthStepPresenter : TKPresenter<LWAuthManagerDelegate> {
    
}

@property (readonly, nonatomic) LWAuthStep stepId;

@end
