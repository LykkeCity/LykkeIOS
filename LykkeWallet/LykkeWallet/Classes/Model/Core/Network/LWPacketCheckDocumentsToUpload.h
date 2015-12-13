//
//  LWPacketCheckDocumentsToUpload.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 12.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacket.h"
#import "LWDocumentsStatus.h"


@interface LWPacketCheckDocumentsToUpload : LWPacket {
    
}
// in
@property (copy, nonatomic) NSString *authCookie;
// out
@property (readonly, nonatomic) LWDocumentsStatus *documentsStatus;

@end
