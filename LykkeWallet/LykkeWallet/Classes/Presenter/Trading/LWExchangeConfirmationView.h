//
//  LWExchangeConfirmationView.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LWAssetPairModel;
@class LWAssetPairRateModel;


@protocol LWExchangeConfirmationViewDelegate <NSObject>

@required
- (void)cancelClicked;
- (void)submitClicked;

@end


@interface LWExchangeConfirmationView : UIView {
    
}


#pragma mark - Properties

@property (strong, nonatomic) LWAssetPairModel     *assetPair;
@property (weak, nonatomic) UIViewController       *controller;

@property (copy, nonatomic) NSString *baseAsset;
@property (copy, nonatomic) NSString *rate;
@property (copy, nonatomic) NSString *volume;
@property (copy, nonatomic) NSString *total;

#pragma mark - General

+ (LWExchangeConfirmationView *)modalViewWithDelegate:(id<LWExchangeConfirmationViewDelegate>)delegate;

@end
