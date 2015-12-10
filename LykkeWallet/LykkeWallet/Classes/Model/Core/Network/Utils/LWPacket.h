//
//  LWPacket.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <GDXNet/GDXNet.h>


@interface LWPacket : GDXNetPacket<GDXRESTPacket> {
    NSDictionary *result;
}

@property (readonly, nonatomic) id   reject;
@property (readonly, nonatomic) BOOL isRejected;

@end
