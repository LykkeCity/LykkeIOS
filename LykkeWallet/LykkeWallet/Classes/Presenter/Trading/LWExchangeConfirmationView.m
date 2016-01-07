//
//  LWExchangeConfirmationView.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeConfirmationView.h"
#import "LWAuthManager.h"
#import "LWConstants.h"
#import "LWValidator.h"
#import "UIViewController+Loading.h"
#import "Macro.h"


@interface LWExchangeConfirmationView () <LWAuthManagerDelegate> {

}

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIView           *topView;
@property (weak, nonatomic) IBOutlet UINavigationBar  *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIButton         *placeOrderButton;


#pragma mark - Properties

@property (weak, nonatomic) id<LWExchangeConfirmationViewDelegate> delegate;


#pragma mark - Utils

- (void)updateView;
- (void)setLoading:(BOOL)loading;

@end


@implementation LWExchangeConfirmationView


#pragma mark - General

+ (LWExchangeConfirmationView *)modalViewWithDelegate:(id<LWExchangeConfirmationViewDelegate>)delegate {

    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LWExchangeConfirmationView"
                                                  owner:self options:nil] objectAtIndex:0];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view sizeToFit];
    
    LWExchangeConfirmationView *result = (LWExchangeConfirmationView *)view;
    [result setDelegate:delegate];
    [result updateView];
    [LWAuthManager instance].delegate = result;
    return result;
}


#pragma mark - Actions

- (void)cancelClicked:(id)sender {
    [self.delegate cancelClicked];
    [self removeFromSuperview];
}

- (IBAction)confirmClicked:(id)sender {
    [self setLoading:YES];
    
    [[LWAuthManager instance] requestPurchaseAsset:self.baseAsset
                                         assetPair:self.assetPair
                                            volume:self.volume
                                              rate:self.rate];
}


#pragma mark - Utils

- (void)updateView {
    [UIView setAnimationsEnabled:NO];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.opaque = NO;
    
    [self.navigationItem setTitle:Localize(@"exchange.assets.model.title")];
    [self.placeOrderButton setTitle:Localize(@"exchange.assets.model.button")
                           forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:Localize(@"exchange.assets.model.cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
    
    UIFont *font = [UIFont fontWithName:kModalNavBarFontName size:kModalNavBarFontSize];
    
    [cancelButton setTitleTextAttributes:@{NSFontAttributeName:font}
                                forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
#warning TODO: validate fingerpint and show modal view
}

- (void)setLoading:(BOOL)loading {
    self.navigationItem.leftBarButtonItem.enabled = !loading;
    [LWValidator setButton:self.placeOrderButton enabled:!loading];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceivePurchaseResponse:(NSString *)orderId {
    [self setLoading:NO];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self setLoading:NO];
    [self.controller showReject:reject];
    [self removeFromSuperview];
}

@end
