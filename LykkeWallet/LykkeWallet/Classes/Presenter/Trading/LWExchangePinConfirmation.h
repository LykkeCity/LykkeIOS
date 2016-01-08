//
//  LWExchangePinConfirmation.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthPresenter.h"


@protocol LWExchangePinConfirmationDelegate <NSObject>

@required
- (void)pinConfirmed;
- (void)pinRejected;

@end


@interface LWExchangePinConfirmation : LWAuthPresenter {
    
}


#pragma mark - Properties

@property (weak, nonatomic) id<LWExchangePinConfirmationDelegate> delegate;

@end
