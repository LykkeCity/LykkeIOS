//
//  LWExchangeConfirmationView.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LWExchangeConfirmationViewDelegate <NSObject>

@required
- (void)cancelClicked;
- (void)submitClicked;

@end


@interface LWExchangeConfirmationView : UIView {
    
}


#pragma mark - Properties

@property (weak, nonatomic) UIViewController *controller;
@property (copy, nonatomic) NSString *baseAsset;
@property (copy, nonatomic) NSString *assetPair;
@property (copy, nonatomic) NSNumber *volume;
@property (copy, nonatomic) NSNumber *rate;


#pragma mark - General

+ (LWExchangeConfirmationView *)modalViewWithDelegate:(id<LWExchangeConfirmationViewDelegate>)delegate;

@end
