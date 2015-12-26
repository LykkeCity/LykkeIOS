//
//  LWPersonalData.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 26.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWPersonalData : NSObject {
    
}


@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *fullName;


#pragma mark - LWPersonalData

- (instancetype)initWithJSON:(id)json;

@end
