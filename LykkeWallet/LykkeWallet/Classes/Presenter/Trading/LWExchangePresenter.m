//
//  LWExchangePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangePresenter.h"
#import "LWExchangeFormPresenter.h"
#import "LWAssetTableViewCell.h"
#import "LWAssetLykkeTableViewCell.h"
#import "LWAssetEmptyTableViewCell.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWCache.h"


#define emptyCellIdentifier @"LWAssetEmptyTableViewCellIdentifier"


@interface LWExchangePresenter () {
    NSMutableIndexSet   *expandedSections;
    NSMutableDictionary *pairRates;
}


#pragma mark - Properties

// array of LWAssetPairModel
@property (readonly, nonatomic) NSArray *assetPairs;


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIView      *headerView;
@property (weak, nonatomic) IBOutlet UILabel     *selectAssetLabel;
@property (weak, nonatomic) IBOutlet UILabel     *assetHeaderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *assetHeaderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel     *assetHeaderChangeLabel;


@end


@implementation LWExchangePresenter


#ifdef PROJECT_IATA
static NSInteger const kNumberOfSections = 1;
static NSInteger const kSectionLykkeAssets = 0;

static NSString *cellIdentifier = @"LWAssetTableViewCellIdentifier";

static NSString *const AssetIdentifiers[kNumberOfSections] = {
    @"LWAssetLykkeTableViewCellIdentifier"
};

static NSString *const AssetNames[kNumberOfSections] = {
    @"IATA"
};

static NSString *const AssetIcons[kNumberOfSections] = {
    @"IATAWallet"
};
#else
static NSInteger const kNumberOfSections = 1;
static NSInteger const kSectionLykkeAssets = 0;

static NSString *cellIdentifier = @"LWAssetTableViewCellIdentifier";

static NSString *const AssetIdentifiers[kNumberOfSections] = {
    @"LWAssetLykkeTableViewCellIdentifier"
};

static NSString *const AssetNames[kNumberOfSections] = {
    @"LYKKE"
};

static NSString *const AssetIcons[kNumberOfSections] = {
    @"WalletLykke"
};
#endif

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = Localize(@"tab.trading");
    
    expandedSections = [NSMutableIndexSet new];
    pairRates = [NSMutableDictionary new];
    
    [self registerCellWithIdentifier:cellIdentifier
                                name:@"LWAssetTableViewCell"];
    
    [self registerCellWithIdentifier:AssetIdentifiers[0]
                                name:@"LWAssetLykkeTableViewCell"];
    
    [self registerCellWithIdentifier:emptyCellIdentifier
                             name:@"LWAssetEmptyTableViewCell"];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
    
    // Expand cells if needed
    if (![expandedSections containsIndex:0]) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController && self.navigationItem) {
        self.tabBarController.title = [self.navigationItem.title uppercaseString];
    }
    
#ifdef PROJECT_IATA
    self.headerView.backgroundColor = self.navigationController.navigationBar.barTintColor;
#endif
    
    [[LWAuthManager instance] requestAssetPairs];
}


#pragma mark - TKPresenter

- (void)localize {
    self.selectAssetLabel.text = Localize(@"exchange.assets.selection");
    self.assetHeaderNameLabel.text = Localize(@"exchange.assets.header.issuer");
    self.assetHeaderPriceLabel.text = Localize(@"exchange.assets.header.price");
    self.assetHeaderChangeLabel.text = Localize(@"exchange.assets.header.change");
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([expandedSections containsIndex:section] && self.assetPairs)
    {
        int const rowCell = 1;
        if (section == kSectionLykkeAssets && self.assetPairs) {
            return MAX(1, self.assetPairs.count) + rowCell;
        }
        else {
            return 2; // general + empty
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    // Show category row
    if (!indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        LWAssetTableViewCell *asset = (LWAssetTableViewCell *)cell;
        if (asset == nil)
        {
            asset = (LWAssetTableViewCell *)[[UITableViewCell alloc]
                                             initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier];
        }
        
        asset.assetLabel.text = AssetNames[indexPath.section];
        asset.assetImageView.image = [UIImage imageNamed:AssetIcons[indexPath.section]];
    }
    // Show wallets for category
    else {
        NSString *identifier = AssetIdentifiers[indexPath.section];
        // Lykke cells
        if (indexPath.section == kSectionLykkeAssets) {
            if (self.assetPairs) {
                // Show Lykke Wallets
                if (self.assetPairs.count > 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    LWAssetLykkeTableViewCell *asset = (LWAssetLykkeTableViewCell *)cell;
                    LWAssetPairModel *assetPair = (LWAssetPairModel *)self.assetPairs[indexPath.row - 1];
                    asset.pair = assetPair;
                    asset.rate = pairRates[assetPair.identity];
                }
                // Show Empty
                else {
                    cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                }
            }
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger const row = indexPath.row;
    // react for assets
    if (row != 0) {
        // lykke assets
        if (indexPath.section == 0) {
            LWAssetPairModel *model = (LWAssetPairModel *)self.assetPairs[row - 1];
            // validate pair
            if (model) {
                LWAssetPairRateModel *rate = pairRates[model.identity];
                // validate rate
                if (rate) {
                    LWExchangeFormPresenter *form = [LWExchangeFormPresenter new];
                    form.assetPair = model;
                    form.assetRate = rate;
                    [self.navigationController pushViewController:form animated:YES];
                }
            }
        }
    }
    // react just for headers
    else {
        // only first row toggles exapand/collapse
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSInteger section = indexPath.section;
        BOOL currentlyExpanded = [expandedSections containsIndex:section];
        NSInteger rows = 0;
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if (currentlyExpanded)
        {
            rows = [self tableView:tableView numberOfRowsInSection:section];
            [expandedSections removeIndex:section];
        }
        else
        {
            [expandedSections addIndex:section];
            rows = [self tableView:tableView numberOfRowsInSection:section];
        }
        
        for (int i = 1; i < rows; i++)
        {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                           inSection:section];
            [tmpArray addObject:tmpIndexPath];
        }
        
        if (currentlyExpanded)
        {
            [tableView deleteRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
        }
        else
        {
            [tableView insertRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

#ifdef PROJECT_IATA
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#endif


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetAssetPairs:(NSArray *)assetPairs {
    _assetPairs = assetPairs;
    
    [[LWAuthManager instance] requestAssetPairRates];
    
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didGetAssetPairRates:(NSArray *)assetPairRates {
    for (LWAssetPairRateModel *rate in assetPairRates) {
        pairRates[rate.identity] = rate;
    }

    [self.tableView reloadData];

    const NSInteger repeatSeconds = [LWCache instance].refreshTimer.integerValue / 1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[LWAuthManager instance] requestAssetPairRates];
    });
}

@end
