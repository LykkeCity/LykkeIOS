//
//  LWExchangeFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeFormPresenter.h"
#import "LWAssetPairModel.h"
#import "LWAssetInfoTextTableViewCell.h"
#import "LWAssetInfoIconTableViewCell.h"
#import "LWCache.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"


@interface LWExchangeFormPresenter () <UITableViewDataSource> {
    LWAssetDescriptionModel *assetDetails;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton    *dealButton;

@end


@implementation LWExchangeFormPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.assetPair.name;
    
    [self setBackButton];
    
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.dealButton.titleLabel.text = @". . .";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    UITableViewCell *cell = nil;
    // Show category row
/*    if (!indexPath.row) {
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
*/
    return cell;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetAssetDescription:(LWAssetDescriptionModel *)assetDescription {
    assetDetails = assetDescription;
    
    [[LWAuthManager instance] requestAssetPairRate:self.assetPair.identity];
}

- (void)authManager:(LWAuthManager *)manager didGetAssetPairRate:(LWAssetPairRateModel *)assetPairRate {

    [self setLoading:NO];
    
    const NSInteger repeatSeconds = [LWCache instance].refreshTimer.integerValue / 1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[LWAuthManager instance] requestAssetPairRate:self.assetPair.identity];
    });
}

@end
