//
//  LWSettingsPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWSettingsPresenter.h"
#import "LWAssetsTablePresenter.h"
#import "LWAuthNavigationController.h"
#import "LWKeychainManager.h"
#import "LWAssetModel.h"
#import "LWSettingsAssetTableViewCell.h"
#import "LWSettingsLogOutTableViewCell.h"
#import "LWRadioTableViewCell.h"


@interface LWSettingsPresenter () {
    LWAssetModel *baseAsset;
}

@end


@implementation LWSettingsPresenter


static NSInteger const kNumberOfRows = 3;

static NSString *const SettingsCells[kNumberOfRows] = {
    @"LWSettingsAssetTableViewCell",
    kRadioTableViewCell,
    @"LWSettingsLogOutTableViewCell"
};

static NSString *const SettingsIdentifiers[kNumberOfRows] = {
    @"LWSettingsAssetTableViewCellIdentifier",
    kRadioTableViewCellIdentifier,
    @"LWSettingsLogOutTableViewCellIdentifier"
};


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.settings");
    
    [self registerCellWithIdentifier:SettingsIdentifiers[0]
                             forName:SettingsCells[0]];
    
    [self registerCellWithIdentifier:SettingsIdentifiers[1]
                             forName:SettingsCells[1]];
    
    [self registerCellWithIdentifier:SettingsIdentifiers[2]
                             forName:SettingsCells[2]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    
    baseAsset = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[LWAuthManager instance] requestBaseAssetGet];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = SettingsIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self configureCell:cell indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && baseAsset) {
        LWAssetsTablePresenter *assets = [LWAssetsTablePresenter new];
        assets.baseAssetId = baseAsset.identity;
        [self.navigationController pushViewController:assets animated:YES];
    }
    else if (indexPath.row == 2) {
        [(LWAuthNavigationController *)self.navigationController logout];
    }
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetBaseAsset:(LWAssetModel *)asset {
    baseAsset = asset;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [self configureCell:cell indexPath:path];
}


#pragma mark - LWAuthenticatedTablePresenter

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LWSettingsAssetTableViewCell *assetCell = (LWSettingsAssetTableViewCell *)cell;
        assetCell.titleLabel.text = Localize(@"settings.cell.asset.title");
        if (baseAsset) {
            assetCell.assetLabel.text = baseAsset.name;
        }
    }
    else if (indexPath.row == 1) {
        LWRadioTableViewCell *radioCell = (LWRadioTableViewCell *)cell;
        radioCell.titleLabel.text = Localize(@"settings.cell.pin.title");
    }
    else if (indexPath.row == 2) {
        LWSettingsLogOutTableViewCell *logoutCell = (LWSettingsLogOutTableViewCell *)cell;
        NSString *logout = [NSString stringWithFormat:@"%@ %@", Localize(@"settings.cell.logout.title"), [LWKeychainManager instance].login];
        logoutCell.logoutLabel.text = logout;
    }
}

@end
