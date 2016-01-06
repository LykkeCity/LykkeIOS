//
//  LWExchangeFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeFormPresenter.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWAssetDescriptionModel.h"
#import "LWAssetInfoTextTableViewCell.h"
#import "LWAssetInfoIconTableViewCell.h"
#import "LWValidator.h"
#import "LWCache.h"
#import "LWMath.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"
#import "NSString+Utils.h"


@interface LWExchangeFormPresenter () <UITableViewDataSource, UITableViewDelegate> {
    LWAssetDescriptionModel *assetDetails;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton    *dealButton;


#pragma mark - Utils

- (void)registerCellWithIdentifier:(NSString *)identifier forName:(NSString *)name;

@end


@implementation LWExchangeFormPresenter


static NSInteger const kDescriptionRows = 6;

static NSString *const DescriptionIdentifiers[kDescriptionRows] = {
    @"LWAssetInfoTextTableViewCellIdentifier",
    @"LWAssetInfoIconTableViewCellIdentifier",
    @"LWAssetInfoTextTableViewCellIdentifier",
    @"LWAssetInfoTextTableViewCellIdentifier",
    @"LWAssetInfoTextTableViewCellIdentifier",
    @"LWAssetInfoTextTableViewCellIdentifier"
};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.assetPair.name;
    
    [self setBackButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerCellWithIdentifier:@"LWAssetInfoTextTableViewCellIdentifier"
                             forName:@"LWAssetInfoTextTableViewCell"];
    
    [self registerCellWithIdentifier:@"LWAssetInfoIconTableViewCellIdentifier"
                             forName:@"LWAssetInfoIconTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateRate:nil];
    [self setLoading:YES];
    
    [[LWAuthManager instance] requestAssetDescription:self.assetPair.identity];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int const kDescriptionRows = 6;
    return kDescriptionRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const DescriptionNames[kDescriptionRows] = {
        Localize(@"exchange.assets.form.assetclass"),
        Localize(@"exchange.assets.form.popularity"),
        Localize(@"exchange.assets.form.description"),
        Localize(@"exchange.assets.form.issuername"),
        Localize(@"exchange.assets.form.coinsnumber"),
        Localize(@"exchange.assets.form.capitalization")
    };
    
    NSString *identifier = DescriptionIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // show popularity row
    if (indexPath.row == 1) {
        LWAssetInfoIconTableViewCell *iconCell = (LWAssetInfoIconTableViewCell *)cell;
        iconCell.titleLabel.text = DescriptionNames[indexPath.row];
        NSString *imageName = [NSString stringWithFormat:@"AssetPopularity%@", assetDetails.popIndex];
        iconCell.popularityImageView.image = [UIImage imageNamed:imageName];
    }
    // show description rows
    else {
        LWAssetInfoTextTableViewCell *textCell = (LWAssetInfoTextTableViewCell *)cell;
        textCell.titleLabel.text = DescriptionNames[indexPath.row];
        textCell.descriptionLabel.text = @"bla bla";
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat const kDefaultRowHeight = 50.0;
    if (assetDetails == nil) {
        return 0;
    }
    
    switch (indexPath.row) {
        case 0:
            return [assetDetails.assetClass isEmpty] ? 0 : kDefaultRowHeight;
        case 1:
            return (assetDetails.popIndex == nil) ? 0 : kDefaultRowHeight;
        case 2:
            return [assetDetails.details isEmpty] ? 0 : kDefaultRowHeight;
        case 3:
            return [assetDetails.issuerName isEmpty] ? 0 : kDefaultRowHeight;
        case 4:
            return [assetDetails.numberOfCoins isEmpty] ? 0 : kDefaultRowHeight;
        case 5:
            return [assetDetails.marketCapitalization isEmpty] ? 0 : kDefaultRowHeight;
        default:
            return kDefaultRowHeight;
    }
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetAssetDescription:(LWAssetDescriptionModel *)assetDescription {
    assetDetails = assetDescription;
 
    [self.tableView reloadData];
    [[LWAuthManager instance] requestAssetPairRate:self.assetPair.identity];
}

- (void)authManager:(LWAuthManager *)manager didGetAssetPairRate:(LWAssetPairRateModel *)assetPairRate {
    
    [self setLoading:NO];

    [self updateRate:assetPairRate];

    const NSInteger repeatSeconds = [LWCache instance].refreshTimer.integerValue / 1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isVisible) {
            [[LWAuthManager instance] requestAssetPairRate:self.assetPair.identity];
        }
    });
}


#pragma mark - Utils

- (void)registerCellWithIdentifier:(NSString *)identifier forName:(NSString *)name {
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)updateRate:(LWAssetPairRateModel *)rate {
    
    NSString *priceRateString = @". . .";
    if (rate) {
        NSDecimalNumber *rateValue = [NSDecimalNumber decimalNumberWithDecimal:[rate.ask decimalValue]];
        NSString *priceString = [LWMath makeStringByDecimal:rateValue withPrecision:self.assetPair.accuracy.integerValue];
        
        priceRateString = [NSString stringWithFormat:@"%@%@", Localize(@"exchange.assets.form.button"), priceString];
    }

    [LWValidator setPriceButton:self.dealButton enabled:(rate != nil)];
    [self.dealButton setTitle:priceRateString forState:UIControlStateNormal];
}

@end
