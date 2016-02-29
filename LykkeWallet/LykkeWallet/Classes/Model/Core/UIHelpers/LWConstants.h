//
//  LWConstants.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 24.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 List of Proxima Fonts
 ProximaNova-Semibold
 ProximaNova-Black
 ProximaNova-Regular
 ProximaNova-LightIt
 ProximaNova-SemiboldIt
 ProximaNova-Extrabld
 ProximaNova-RegularIt
 ProximaNovaT-Thin
 ProximaNova-Light
 ProximaNova-ExtrabldIt
 ProximaNova-Bold
 ProximaNova-BlackIt
 ProximaNova-BoldIt
 ProximaNova-ThinIt
 */


#pragma mark - Server Constants

#define kProductionServer  @"api.lykkex.com"

#define kStagingTestServer @"lykke-api-test.azurewebsites.net"
#define kDevelopTestServer @"lykke-api-dev.azurewebsites.net"
#define kDemoTestServer    @"lykke-api-demo.azurewebsites.net"


#pragma mark - General Constants

#define kFontBold @"ProximaNova-Bold"
#define kFontLight @"ProximaNova-Light"
#define kFontRegular @"ProximaNova-Regular"
#define kFontSemibold @"ProximaNova-Semibold"

#define kMainElementsColor @"AB00FF"
#define kMainWhiteElementsColor @"FFFFFF"
#define kMainDarkElementsColor @"3F4D60"
#define kMainGrayElementsColor @"EAEDEF"


#pragma mark - Button Constants

static NSString *const kLabelFontColor = kMainDarkElementsColor;


#pragma mark - Button Constants

static float     const kButtonFontSize  = 15.0;
static NSString *const kButtonFontName  = kFontSemibold;
static NSString *const kDisabledButtonFontColor = @"D6D6D6";
static NSString *const kEnabledButtonFontColor = @"FFFFFF";
static NSString *const kSellAssetButtonColor = @"FF3E2E";


#pragma mark - Text Field Constants

static float     const kTextFieldFontSize  = 17.0;
static NSString *const kTextFieldFontColor = kMainDarkElementsColor;
static NSString *const kTextFieldFontName  = kFontRegular;


#pragma mark - Navigation Bar Constants

static NSString *const kNavigationBarTintColor  = kMainElementsColor;
static NSString *const kNavigationBarGrayColor  = kMainGrayElementsColor;
static NSString *const kNavigationBarWhiteColor = kMainWhiteElementsColor;

static float     const kNavigationBarFontSize   = 17.0;
static NSString *const kNavigationBarFontColor  = kMainDarkElementsColor;
static NSString *const kNavigationBarFontName   = kFontSemibold;

static float     const kModalNavBarFontSize     = 15.0;
static NSString *const kModalNavBarFontName     = kFontRegular;


#pragma mark - Page Control Constants

static NSString *const kPageControlDotColor       = @"D3D6DB";
static NSString *const kPageControlActiveDotColor = kMainElementsColor;


#pragma mark - Asset Colors

static float     const kAssetDetailsFontSize      = 17.0;
static NSString *const kAssetChangePlusColor      = @"53AA00";
static NSString *const kAssetChangeMinusColor     = @"FF2E2E";


#pragma mark - Table Cells

static float     const kTableCellDetailFontSize   = 22.0;
static NSString *const kTableCellLightFontName    = kFontLight;
static NSString *const kTableCellRegularFontName  = kFontRegular;

