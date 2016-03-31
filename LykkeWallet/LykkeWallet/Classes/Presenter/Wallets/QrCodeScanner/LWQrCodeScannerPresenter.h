//
//  LWQrCodeScannerPresenter.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 30.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAuthPresenter.h"
#import "QRCodeReader.h"


@interface LWQrCodeScannerPresenter : LWAuthPresenter {
    
}

@property (strong, nonatomic, readonly) NSArray *metadataObjectTypes;
@property (strong, nonatomic, readonly) QRCodeReader *codeReader;

@end
