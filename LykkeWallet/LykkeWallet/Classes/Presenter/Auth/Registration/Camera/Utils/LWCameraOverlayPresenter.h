//
//  LWCameraOverlayPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 26.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"
#import "NSObject+GDXObserver.h"

@protocol LWCameraOverlayDelegate<NSObject>
@required
- (void)fileChoosen:(NSDictionary<NSString *,id> *)info;
@end


@interface LWCameraOverlayPresenter : TKPresenter {
    
}

@property (weak, nonatomic) id<LWCameraOverlayDelegate> delegate;
@property (weak, nonatomic) UIImagePickerController *pickerReference;
@property (nonatomic) BOOL isSelfieView;

- (void)updateView;

@end
