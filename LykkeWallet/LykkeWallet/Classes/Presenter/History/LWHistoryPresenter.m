//
//  LWHistoryPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWHistoryPresenter.h"


@interface LWHistoryPresenter () {
    
}

@end


@implementation LWHistoryPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.history");
}


#pragma mark - Just for demo

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
        [cell.textLabel setText:@"History"];
    }
    
    return cell;
}

@end
