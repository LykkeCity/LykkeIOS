//
//  AppDelegate.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 08.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ABPadLockScreen.h"
// tab presenters
#import "LWWalletsPresenter.h"
#import "LWTradingPresenter.h"
#import "LWHistoryPresenter.h"
#import "LWSettingsPresenter.h"

@implementation AppDelegate

static NSString *const BORDER_COLOR = @"D3D6DB";
static NSString *const MAIN_COLOR = @"AB00FF";

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // init fabric
    [Fabric with:@[[Crashlytics class]]];
    // customize PIN screen
    [[ABPadLockScreenView appearance] setBackgroundColor:[UIColor whiteColor]];
    [[ABPadLockScreenView appearance] setLabelColor:[UIColor blackColor]];
    [[ABPadButton appearance] setBackgroundColor:[UIColor clearColor]];
    [[ABPadButton appearance] setBorderColor:[UIColor colorWithHexString:BORDER_COLOR]];
    [[ABPadButton appearance] setSelectedColor:[UIColor lightGrayColor]];
    [[ABPadButton appearance] setTextColor:[UIColor blackColor]];
    [[ABPinSelectionView appearance] setSelectedColor:[UIColor colorWithHexString:MAIN_COLOR]];
    // init tab presenters
    LWWalletsPresenter *pWallets = [LWWalletsPresenter new];
    pWallets.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:Localize(@"tab.wallets")
                           image:[UIImage imageNamed:@"WalletsTab"]
                           selectedImage:nil];

    LWTradingPresenter *pTrading = [LWTradingPresenter new];
    pTrading.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:Localize(@"tab.trading")
                           image:[UIImage imageNamed:@"TradingTab"]
                           selectedImage:nil];
    
    LWHistoryPresenter *pHistory = [LWHistoryPresenter new];
    pHistory.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:Localize(@"tab.history")
                           image:[UIImage imageNamed:@"HistoryTab"]
                           selectedImage:nil];
    
    LWSettingsPresenter *pSettings = [LWSettingsPresenter new];
    pSettings.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:Localize(@"tab.settings")
                            image:[UIImage imageNamed:@"SettingsTab"]
                            selectedImage:nil];
    
    // init tab controller
    self.tabController = [LWTabController new];
    self.tabController.viewControllers = @[pWallets, pTrading, pHistory, pSettings];
    self.tabController.tabBar.tintColor = [UIColor colorWithHexString:MAIN_COLOR];
    
    // init window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
