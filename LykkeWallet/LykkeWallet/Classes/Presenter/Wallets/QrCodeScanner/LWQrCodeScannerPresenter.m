//
//  LWQrCodeScannerPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 30.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWQrCodeScannerPresenter.h"
#import "UIViewController+Navigation.h"
#import <AVFoundation/AVFoundation.h>


@interface LWQrCodeScannerPresenter ()<AVCaptureMetadataOutputObjectsDelegate> {
    
}

@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end


@implementation LWQrCodeScannerPresenter


+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    if ((self = [super init])) {
        _metadataObjectTypes = metadataObjectTypes;
        
        [self setupAVComponents];
        [self configureDefaultComponents];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackButton];
    [self setupAVComponents];
    [self configureDefaultComponents];
    
    self.title = Localize(@"test!!!");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)setupAVComponents
{
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
        self.session            = [[AVCaptureSession alloc] init];
        self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
}

- (void)configureDefaultComponents
{
    [_session addOutput:_metadataOutput];
    
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_metadataOutput setMetadataObjectTypes:_metadataObjectTypes];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}


#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [_metadataObjectTypes containsObject:current.type]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            
//            if (_completionBlock) {
//                _completionBlock(scannedResult);
//            }
            
            break;
        }
    }
}

@end
