//
//  LWExchangeConfirmationView.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeConfirmationView.h"
#import "LWDetailTableViewCell.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWAuthManager.h"
#import "LWConstants.h"
#import "LWValidator.h"
#import "UIViewController+Loading.h"
#import "Macro.h"

#import <LocalAuthentication/LocalAuthentication.h>


@interface LWExchangeConfirmationView () <UITableViewDataSource, LWAuthManagerDelegate> {

}

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIView           *topView;
@property (weak, nonatomic) IBOutlet UITableView      *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar  *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIButton         *placeOrderButton;


#pragma mark - Properties

@property (weak, nonatomic) id<LWExchangeConfirmationViewDelegate> delegate;


#pragma mark - Utils

- (void)requestOperation;
- (void)validateUser;
- (BOOL)isFingerprintAvailable;
- (void)updateView;
- (void)setLoading:(BOOL)loading;
- (void)registerCellWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end


@implementation LWExchangeConfirmationView


static int const kDescriptionRows = 3;


#pragma mark - General

+ (LWExchangeConfirmationView *)modalViewWithDelegate:(id<LWExchangeConfirmationViewDelegate>)delegate {

    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LWExchangeConfirmationView"
                                                  owner:self options:nil] objectAtIndex:0];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view sizeToFit];
    
    LWExchangeConfirmationView *result = (LWExchangeConfirmationView *)view;
    [result setDelegate:delegate];
    [result updateView];
    return result;
}


#pragma mark - Actions

- (void)cancelClicked:(id)sender {
    [self.delegate cancelClicked];
    [self removeFromSuperview];
}

- (IBAction)confirmClicked:(id)sender {
    [self requestOperation];
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


#pragma mark - Utils

- (void)requestOperation {
    [self setLoading:YES];
    
    [[LWAuthManager instance] requestPurchaseAsset:self.baseAsset
                                         assetPair:self.assetPair.identity
                                            volume:self.volume
                                              rate:self.assetRate.ask];
}

- (void)validateUser {
    if ([self isFingerprintAvailable]) {
        LAContext *laContext = [[LAContext alloc] init];
        NSString *reasonString = Localize(@"exchange.assets.modal.fingerpring");
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:reasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self requestOperation];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self cancelClicked:self.placeOrderButton];
                                    });
                                }
                            }];
    } else {
        // fingerprint unavailable - do nothing
    }
}

- (BOOL)isFingerprintAvailable {
    LAContext *laContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        return (authError != nil);
    }
    return NO;
}

- (void)updateView {
    [UIView setAnimationsEnabled:NO];
    
    [LWAuthManager instance].delegate = self;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.opaque = NO;
    
    [self.navigationItem setTitle:Localize(@"exchange.assets.modal.title")];
    [self.placeOrderButton setTitle:Localize(@"exchange.assets.modal.button")
                           forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:Localize(@"exchange.assets.modal.cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
    
    UIFont *font = [UIFont fontWithName:kModalNavBarFontName size:kModalNavBarFontSize];
    
    [cancelButton setTitleTextAttributes:@{NSFontAttributeName:font}
                                forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.placeOrderButton.hidden = [self isFingerprintAvailable];
    
    [self registerCellWithIdentifier:kDetailTableViewCellIdentifier
                                name:kDetailTableViewCell];
    
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // if fingerprint available - show confirmation view
    [self validateUser];
}

- (void)setLoading:(BOOL)loading {
    self.navigationItem.leftBarButtonItem.enabled = !loading;
    [LWValidator setButton:self.placeOrderButton enabled:!loading];
}

- (void)registerCellWithIdentifier:(NSString *)identifier name:(NSString *)name {
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kDescriptionRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const titles[kDescriptionRows] = {
        Localize(@"exchange.assets.buy.sum"),
        Localize(@"exchange.assets.buy.price"),
        Localize(@"exchange.assets.buy.total")
    };
    
    NSString *const values[kDescriptionRows] = {
        self.volume,
        self.rate,
        self.total
    };
    
    LWDetailTableViewCell *cell = (LWDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kDetailTableViewCellIdentifier];
    if (indexPath.row == kDescriptionRows - 1) {
        [cell setRegularDetails];
    }
    else {
        [cell setLightDetails];
    }

    [cell setWhitePalette];
    cell.titleLabel.text = titles[indexPath.row];
    cell.detailLabel.text = values[indexPath.row];
    
    return cell;
}

@end
