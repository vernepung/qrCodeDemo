//
//  VPScanQrCodeView.m
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//

#import "VPScanQrCodeView.h"
#import "VPScanMaskView.h"
#import <AVFoundation/AVFoundation.h>

const char *queueLabel = "queueLabel";
const CGFloat scanViewWidth = 240;
@interface VPScanQrCodeView()<AVCaptureMetadataOutputObjectsDelegate>
{

}
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) VPScanMaskView *maskView;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end


@implementation VPScanQrCodeView
- (void)dealloc
{
    NSLog(@"%@",@"dealloc");
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (!deviceInput)
    {
        NSLog(@"打开摄像头错误：%@",[error localizedDescription]);
    }
    else
    {
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
        [self.captureSession addInput:deviceInput];
        [self.captureSession addOutput:metadataOutput];
        
        CGSize size = self.bounds.size;
        CGRect cropRect = CGRectMake((size.width - scanViewWidth) / 2, (size.height - 64.0f - scanViewWidth) / 2, scanViewWidth, scanViewWidth);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight = scanViewWidth * p2;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            metadataOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                       cropRect.origin.x/size.width,
                                                       cropRect.size.height/fixHeight,
                                                       cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = scanViewWidth * p2;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            metadataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                       (cropRect.origin.x + fixPadding)/fixWidth,
                                                       cropRect.size.height/size.height,
                                                       cropRect.size.width/fixWidth);
        }
        
        self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
        [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.videoPreviewLayer setFrame:self.layer.bounds];
        [self.layer insertSublayer:self.videoPreviewLayer atIndex:0];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("queueLabel", NULL);
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        [self.captureSession startRunning];
    }
}

- (void)didMoveToSuperview
{
    self.maskView = [[VPScanMaskView alloc] initWithFrame:self.bounds scanViewWidth:220];
    self.maskView.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:self.maskView];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!metadataObjects || metadataObjects.count <= 0)return;
    AVMetadataMachineReadableCodeObject *codeObj = [metadataObjects objectAtIndex:0];
    if ([[codeObj type] isEqualToString:AVMetadataObjectTypeQRCode])
    {
        [self.maskView stopAnimation];
        [self.captureSession stopRunning];
    }
    NSLog(@"%@",codeObj.stringValue);
}

@end
