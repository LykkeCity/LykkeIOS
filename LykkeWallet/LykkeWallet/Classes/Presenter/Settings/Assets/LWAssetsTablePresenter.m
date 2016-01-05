//
//  LWAssetsTablePresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 02.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAssetsTablePresenter.h"
#import "LWChooseAssetTableViewCell.h"
#import "LWAuthManager.h"
#import "LWAssetModel.h"
#import "LWConstants.h"

#import "UIColor+Generic.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"


@interface LWAssetsTablePresenter () {
    
}

@property (readonly, nonatomic) NSArray *assets;

@end


@implementation LWAssetsTablePresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"settings.assets.title");
    
    [self setBackButton];
    
    [self registerCellWithIdentifier:@"LWChooseAssetTableViewCellIdentifier"
                             forName:@"LWChooseAssetTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setLoading:YES];
    [[LWAuthManager instance] requestBaseAssets];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetBaseAssets:(NSArray *)assets {
    [self setLoading:NO];
    
    _assets = assets;
    [self.tableView reloadData];
}

- (void)authManagerDidSetAsset:(LWAuthManager *)manager {
    [self setLoading:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.assets ? self.assets.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LWChooseAssetTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LWChooseAssetTableViewCell *cell = (LWChooseAssetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (cell && self.baseAssetId) {
        // do nothing
        if ([cell.assetId isEqualToString:self.baseAssetId]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [[LWAuthManager instance] requestBaseAssetSet:cell.assetId];
            
            [self setLoading:YES];
        }
    }
}


#pragma mark - LWAuthenticatedTablePresenter

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    LWChooseAssetTableViewCell *itemCell = (LWChooseAssetTableViewCell *)cell;
    LWAssetModel *model = (LWAssetModel *)[self.assets objectAtIndex:indexPath.row];
    if (model && itemCell) {
        itemCell.assetId        = model.identity;
        itemCell.assetName.text = model.name;
        itemCell.tintColor = [UIColor colorWithHexString:kMainElementsColor];
        // set checkmark for base asset
        if (self.baseAssetId &&
            [model.identity isEqualToString:self.baseAssetId]) {
            itemCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            itemCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

@end
