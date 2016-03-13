//
//  LWAssetLykkeTableViewCell.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAssetLykkeTableViewCell.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWConstants.h"
#import "LWColorizer.h"
#import "LWMath.h"



@interface LWAssetLykkeTableChangeView () {
    
}

@property (copy, nonatomic) NSArray *changes;

@end

@implementation LWAssetLykkeTableChangeView

- (void)drawRect:(CGRect)rect {
    
    if (self.changes && self.changes.count > 2) {
        // calculation preparation
        CGFloat xPosition = 0.0;
        CGSize const size = self.frame.size;
        CGFloat const xStep = size.width / (CGFloat)self.changes.count;
        NSNumber *firstPoint = self.changes[0];
        NSNumber *lastPoint = self.changes[self.changes.count - 1];

        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 0.5;
        [path moveToPoint:CGPointMake(xPosition, [self point:firstPoint forSize:size])];

        // prepare drawing data
        for (NSNumber *change in self.changes) {
            CGFloat const yPosition = [self point:change forSize:size];
            [path addLineToPoint:CGPointMake(xPosition, yPosition)];
            xPosition += xStep;
        }
        
        UIColor *color = nil;
        // set negative or positive color
        if (firstPoint.doubleValue >= lastPoint.doubleValue) {
            color = [UIColor colorWithHexString:kAssetChangeMinusColor];
        }
        else {
            color = [UIColor colorWithHexString:kAssetChangePlusColor];
        }
        // draw
        [color setStroke];
        [path stroke];
        
        // draw last point
        CGRect rect = CGRectMake(xPosition - xStep, [self point:lastPoint forSize:size], 2.0, 2.0);
        UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [color set];
        [cicle fill];
    }
}

- (CGFloat)point:(NSNumber *)point forSize:(CGSize)size {
    return size.height * (1.0 - point.doubleValue);
}

@end


@implementation LWAssetLykkeTableViewCell

- (void)setRate:(LWAssetPairRateModel *)rate {
    _rate = rate;
    
    [self.assetChangeView setChanges:rate.lastChanges];
    [self.assetChangeView setNeedsDisplay];
    
    if (self.rate && self.pair) {
        // price section
        NSString *priceString = [LWMath priceString:rate.ask precision:self.pair.accuracy withPrefix:@"$ "];
        self.assetPriceLabel.text = priceString;
        self.assetPriceLabel.textColor = [UIColor colorWithHexString:kAssetEnabledItemColor];

        // change section
        NSString *sign = (rate.pchng.doubleValue >= 0.0) ? @"+" : @"";
        NSString *changeString = [LWMath priceString:rate.pchng precision:[NSNumber numberWithInt:2] withPrefix:sign];

        UIColor *changeColor = (rate.pchng.doubleValue >= 0.0)
                                ? [UIColor colorWithHexString:kAssetChangePlusColor]
                                : [UIColor colorWithHexString:kAssetChangeMinusColor];
        self.assetChangeLabel.textColor = changeColor;
        self.assetChangeLabel.text = [NSString stringWithFormat:@"%@%%", changeString];
        
        self.assetPriceImageView.image = [UIImage imageNamed:@"AssetPriceArea"];
    }
    else {
        self.assetPriceLabel.text = @". . .";
        self.assetPriceLabel.textColor = [UIColor colorWithHexString:kAssetDisabledItemColor];
        self.assetChangeLabel.text = @". . .";
        self.assetChangeLabel.textColor = [UIColor colorWithHexString:kMainDarkElementsColor];
        self.assetPriceImageView.image = [UIImage imageNamed:@"AssetPriceDisabledArea"];
    }
}

- (void)setPair:(LWAssetPairModel *)pair {
    _pair = pair;
    
    self.assetNameLabel.text = pair.name;
}

@end
