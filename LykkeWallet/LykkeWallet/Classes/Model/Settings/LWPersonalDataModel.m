//
//  LWPersonalDataModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 21.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWPersonalDataModel.h"


@implementation LWPersonalDataModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        _fullName = json[@"FullName"];
        _email    = json[@"Email"];
        _phone    = json[@"Phone"];
        _country  = json[@"Country"];
        _address  = json[@"Address"];
        _city     = json[@"City"];
        _zip      = json[@"Zip"];
    }
    return self;
}

@end
