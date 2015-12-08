//
//  TKColorizer.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKColorizer.h"


@implementation TKColorizer

SINGLETON_INIT_EMPTY


#pragma mark - Properties

- (CAGradientLayer *)gradientButton {
    UIColor *colorOne = [UIColor colorWithHexString:@"1DB2DC"];
    UIColor *colorTwo = [UIColor colorWithHexString:@"085DC3"];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = colors;
    gradient.locations = locations;
    gradient.startPoint = CGPointMake(0.25, 0.0);
    gradient.endPoint = CGPointMake(0.75, 1.0);
    
    return gradient;
}

@end
