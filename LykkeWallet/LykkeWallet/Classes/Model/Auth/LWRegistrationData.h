//
//  LWRegistrationData.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 11.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LWRegistrationData : NSObject {
    
}

@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *password;

@end

NS_ASSUME_NONNULL_END
