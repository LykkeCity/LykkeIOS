//
//  TKPresenter+Loading.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 16.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"
#import "MBProgressHUD.h"


@interface TKPresenter (Loading)

- (void)setLoading:(BOOL)loading;
- (MBProgressHUD *)hud;
- (void)showReject:(NSDictionary *)reject;

@end
