//
//  LWAppSettingsModel.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWJSONObject.h"


@interface LWAppSettingsModel : LWJSONObject {
    
}


#pragma mark - Properties

@property (readonly, nonatomic) NSNumber *rateRefreshPeriod;

@end
