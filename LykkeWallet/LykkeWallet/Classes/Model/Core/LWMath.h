//
//  LWMath.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWMath : NSObject {
    
}

+ (NSDecimalNumber *)numberWithString:(NSString *)stringNumber;
+ (NSDecimalNumber *)roundNumber:(NSDecimalNumber *)number withDigits:(NSInteger)digits;
+ (NSDecimalNumber *)abs:(NSDecimalNumber *)number;
+ (NSDecimalNumber *)changeSign:(NSDecimalNumber *)number;
+ (BOOL)isDoubleEqualToZero:(double)value;
+ (BOOL)isDecimalEqualToZero:(NSDecimalNumber *)number;

+ (NSString *)makeStringByDecimal:(NSDecimalNumber *)number withPrecision:(NSInteger)precision;
+ (NSString *)makeEditStringByDecimal:(NSDecimalNumber *)number withPrecision:(NSInteger)precision;
+ (NSString *)makeCurrencyPrice:(NSDecimalNumber *)number;
+ (NSString *)makeRateFromDebit:(NSDecimalNumber *)debit andCredit:(NSDecimalNumber *)credit;
+ (NSString *)makeRateFromPrice:(NSDecimalNumber *)fromPrice toPrice:(NSDecimalNumber *)toPrice;
+ (NSString *)priceString:(NSNumber *)value precision:(NSNumber *)precision withPrefix:(NSString *)prefix;

@end
