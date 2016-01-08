//
//  LWMath.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWMath.h"


@implementation LWMath

+ (NSDecimalNumber *)numberWithString:(NSString *)stringNumber
{
    NSLocale *locale = [NSLocale currentLocale];
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterDecimalStyle];
    [frm setLocale:locale];
    NSNumber *number = [frm numberFromString:stringNumber];
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    
    if ([LWMath isDecimalEqualToZero:result])
    {
        result = [NSDecimalNumber zero];
    }
    return result;
}

+ (NSDecimalNumber *)roundNumber:(NSDecimalNumber *)number withDigits:(NSInteger)digits
{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                       scale:digits raiseOnExactness:NO raiseOnOverflow:NO
                                       raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [number decimalNumberByRoundingAccordingToBehavior:handler];
    return result;
}

+ (BOOL)isDoubleEqualToZero:(double)value
{
    NSNumber *number = [NSNumber numberWithDouble:value];
    BOOL const result = [number isEqualToNumber:[NSNumber numberWithDouble:0.0]];
    return result;
}

+ (BOOL)isDecimalEqualToZero:(NSDecimalNumber *)number
{
    BOOL const result = [LWMath isDoubleEqualToZero:number.doubleValue];
    return result;
}

+ (NSDecimalNumber *)abs:(NSDecimalNumber *)number
{
    if ([number compare:[NSDecimalNumber zero]] == NSOrderedAscending)
    {
        return [LWMath changeSign:number];
    }
    return number;
}

+ (NSDecimalNumber *)changeSign:(NSDecimalNumber *)number
{
    NSDecimalNumber *minus = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:-1] decimalValue]];
    return [number decimalNumberByMultiplyingBy:minus];
}

+ (NSString *)makeCurrencyPrice:(NSDecimalNumber *)number
{
    NSString *result = [LWMath makeEditStringByDecimal:number withPrecision:2];
    return result;
}

+ (NSString *)makeRateFromPrice:(NSDecimalNumber *)fromPrice toPrice:(NSDecimalNumber *)toPrice
{
    if (![LWMath isDecimalEqualToZero:toPrice])
    {
        NSDecimalNumber *devided = [fromPrice decimalNumberByDividingBy:toPrice];
        NSString *result = [LWMath makeEditStringByDecimal:devided withPrecision:4];
        return result;
    }
    return @"1";
}

+ (NSString *)makeRateFromDebit:(NSDecimalNumber *)debit andCredit:(NSDecimalNumber *)credit
{
    if (![LWMath isDecimalEqualToZero:credit])
    {
        NSDecimalNumber *devided = [debit decimalNumberByDividingBy:credit];
        NSString *result = [LWMath makeEditStringByDecimal:devided withPrecision:4];
        return result;
    }
    return @"1";
}

+ (NSString *)makeStringByNumber:(NSNumber *)number withPrecision:(NSInteger)precision {
    if (!number || [number isKindOfClass:[NSNull class]]) {
        return @" - ";
    }
    
    NSDecimalNumber *decimalRate = [NSDecimalNumber
                                    decimalNumberWithDecimal:number.decimalValue];
    NSString *result = [LWMath makeStringByDecimal:decimalRate withPrecision:precision];
    return result;
}

+ (NSString *)makeStringByDecimal:(NSDecimalNumber *)number withPrecision:(NSInteger)precision
{
    NSLocale *locale = [NSLocale currentLocale];
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterDecimalStyle];
    [frm setMaximumFractionDigits:precision];
    [frm setMinimumFractionDigits:precision];
    [frm setLocale:locale];
    NSString *result = [frm stringFromNumber:[NSNumber numberWithDouble:number.doubleValue]];
    return result;
}

+ (NSString *)makeEditStringByDecimal:(NSDecimalNumber *)number withPrecision:(NSInteger)precision
{
    NSLocale *locale = [NSLocale currentLocale];
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterDecimalStyle];
    [frm setMaximumFractionDigits:precision];
    [frm setMinimumFractionDigits:precision];
    [frm setLocale:locale];
    [frm setUsesGroupingSeparator:NO];
    NSString *result = [frm stringFromNumber:[NSNumber numberWithDouble:number.doubleValue]];
    return result;
}

+ (NSString *)priceString:(NSNumber *)value precision:(NSNumber *)precision withPrefix:(NSString *)prefix {

    NSString *priceRateString = @". . .";

    NSDecimalNumber *rateValue = [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
    NSString *priceString = [LWMath makeStringByDecimal:rateValue withPrecision:precision.integerValue];
        
    priceRateString = [NSString stringWithFormat:@"%@%@", prefix, priceString];
    return priceRateString;
}

@end
