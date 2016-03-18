//
//  LWTradingGraphPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 18.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTradingGraphPresenter.h"
#import "LWAssetPairRateModel.h"
#import "LWAssetPairModel.h"
#import "LWCache.h"
#import "LWLeftDetailTableViewCell.h"
#import "LWValidator.h"
#import "LWMath.h"
#import "TKButton.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"


@interface LWTradingGraphPresenter () {
    
}

@property (assign, nonatomic) BOOL isValid;
@property (strong, nonatomic) LWAssetPairRateModel *pairRateModel;

@property (weak, nonatomic) IBOutlet TKButton *sellButton;
@property (weak, nonatomic) IBOutlet TKButton *buyButton;


#pragma mark - Utils
- (void)updateTitleCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row;
- (void)updateValueCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row;
- (void)requestPrices;
- (void)updatePrices;
- (void)invalidPrices;

@end


@implementation LWTradingGraphPresenter

static int const kNumberOfRows = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.asset.name;

    self.isValid = NO;
    self.pairRateModel = nil;
    
    [self registerCellWithIdentifier:kLeftDetailTableViewCellIdentifier
                                name:kLeftDetailTableViewCell];
    
    [self setBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[LWAuthManager instance] requestAssetPairRate:self.asset.identity];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWLeftDetailTableViewCell *cell = (LWLeftDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kLeftDetailTableViewCellIdentifier];
    
    [self updateTitleCell:cell row:indexPath.row];
    [self updateValueCell:cell row:indexPath.row];
    
    return cell;
}


#pragma mark - Utils

- (void)updateTitleCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row {
    NSString *const titles[kNumberOfRows] = {
        Localize(@"graph.cell.time"),
        Localize(@"graph.cell.price"),
        Localize(@"graph.cell.change")
    };
    cell.titleLabel.text = titles[row];
}

- (void)updateValueCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row {
    
    NSString *values[kNumberOfRows] = {
        @" - ",
        @" - ",
        @" - "
    };
    
    if (self.isValid) {
        values[0] = @"4:30 PM EST";
        values[1] = [LWMath makeStringByNumber:self.pairRateModel.ask
                                 withPrecision:self.asset.accuracy.integerValue];
        values[2] = @"<x> <x>%";
    }

    cell.detailLabel.text = values[row];
    //[cell.detailLabel setTextColor:[UIColor colorWithHexString:kMainDarkElementsColor]];
}

- (void)requestPrices {
    const NSInteger repeatSeconds = [LWCache instance].refreshTimer.integerValue / 1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isVisible) {
            [[LWAuthManager instance] requestAssetPairRate:self.asset.identity];
        }
    });
}

- (void)updatePrices {
    [LWValidator setBuyButton:self.buyButton enabled:YES];
    [LWValidator setSellButton:self.sellButton enabled:YES];
    
    NSString *priceSellRateString = @". . .";
    NSString *priceBuyRateString = @". . .";
    if (self.pairRateModel) {
        priceSellRateString = [LWMath priceString:self.pairRateModel.ask precision:self.asset.accuracy withPrefix:Localize(@"graph.button.sell")];
        priceBuyRateString = [LWMath priceString:self.pairRateModel.bid precision:self.asset.accuracy withPrefix:Localize(@"graph.button.buy")];
    }
    
    [self.sellButton setTitle:priceSellRateString forState:UIControlStateNormal];
    [self.buyButton setTitle:priceBuyRateString forState:UIControlStateNormal];

    [self.tableView reloadData];
}

- (void)invalidPrices {
    [LWValidator setBuyButton:self.buyButton enabled:self.isValid];
    [LWValidator setSellButton:self.sellButton enabled:self.isValid];
    
    [self.tableView reloadData];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetAssetPairRate:(LWAssetPairRateModel *)assetPairRate {
    self.pairRateModel = assetPairRate;
    self.isValid = YES;
    
    [self updatePrices];
    [self requestPrices];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    self.isValid = NO;
    
    [self invalidPrices];
    [self requestPrices];
}

@end
