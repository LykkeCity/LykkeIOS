//
//  LWExchangeBuyFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 06.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeBuyFormPresenter.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "UIViewController+Navigation.h"


@interface LWExchangeBuyFormPresenter () {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end


@implementation LWExchangeBuyFormPresenter


static NSInteger const kFormRows = 3;

static NSString *const FormIdentifiers[kFormRows] = {
    @"LWAssetBuySumTableViewCellIdentifier",
    @"LWAssetBuyPriceTableViewCellIdentifier",
    @"LWAssetBuyTotalTableViewCellIdentifier"
};


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@%@", Localize(@"exchange.assets.buy.title"), self.assetPair.name];
    
    //[self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
    
    [self registerCellWithIdentifier:@"LWAssetBuySumTableViewCellIdentifier"
                                name:@"LWAssetBuySumTableViewCell"];
    
    [self registerCellWithIdentifier:@"LWAssetBuyPriceTableViewCellIdentifier"
                                name:@"LWAssetBuyPriceTableViewCell"];
    
    [self registerCellWithIdentifier:@"LWAssetBuyTotalTableViewCellIdentifier"
                                name:@"LWAssetBuyTotalTableViewCell"];
    
    [self setBackButton];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kFormRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const DescriptionNames[kFormRows] = {
        Localize(@"exchange.assets.form.assetclass"),
        Localize(@"exchange.assets.form.popularity"),
        Localize(@"exchange.assets.form.description")
    };
    
    NSString *identifier = FormIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell;
}

@end
