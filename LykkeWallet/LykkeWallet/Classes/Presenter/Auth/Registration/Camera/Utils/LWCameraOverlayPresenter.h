//
//  LWCameraOverlayPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 26.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"
#import "NSObject+GDXObserver.h"


@interface LWCameraOverlayPresenter : TKPresenter {
    
}

@property (weak, nonatomic) UIImagePickerController *pickerReference;
@property (nonatomic) BOOL isSelfieView;

- (void)updateView;

@end
